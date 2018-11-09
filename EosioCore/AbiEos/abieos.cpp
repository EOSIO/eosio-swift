// copyright defined in abieos/LICENSE.txt

#pragma clang diagnostic ignored "-Weverything"

#include "abieos.h"
#include "abieos.hpp"

#include <memory>

using namespace abieos;

struct abieos_context_s {
    const char* last_error = "";
    std::string last_error_buffer{};
    std::string result_str{};
    std::vector<char> result_bin{};

    std::map<name, contract> contracts{};
};

void fix_null_str(const char*& s) {
    if (!s)
        s = "";
}

void set_error(abieos_context* context, const char* error) noexcept {
    try {
        context->last_error_buffer = error;
        context->last_error = context->last_error_buffer.c_str();
    } catch (...) {
        context->last_error = "exception while recording error";
    }
}

template <typename T, typename F>
auto handle_exceptions(abieos_context* context, T errval, F f) noexcept -> decltype(f()) {
    if (!context)
        return errval;
    try {
        return f();
    } catch (std::exception& e) {
        set_error(context, e.what());
        return errval;
    } catch (...) {
        set_error(context, "unknown exception");
        return errval;
    }
}

extern "C" abieos_context* abieos_create() {
    try {
        return new abieos_context{};
    } catch (...) {
        return nullptr;
    }
}

extern "C" void abieos_destroy(abieos_context* context) { delete context; }

extern "C" const char* abieos_get_error(abieos_context* context) {
    if (!context)
        return "context is null";
    return context->last_error;
}

extern "C" int abieos_get_bin_size(abieos_context* context) {
    if (!context)
        return 0;
    return context->result_bin.size();
}

extern "C" const char* abieos_get_bin_data(abieos_context* context) {
    if (!context)
        return nullptr;
    return context->result_bin.data();
}

extern "C" const char* abieos_get_bin_hex(abieos_context* context) {
    return handle_exceptions(context, nullptr, [&] {
        context->result_str.clear();
        boost::algorithm::hex(context->result_bin.begin(), context->result_bin.end(),
                              std::back_inserter(context->result_str));
        return context->result_str.c_str();
    });
}

extern "C" uint64_t abieos_string_to_name(abieos_context* context, const char* str) {
    fix_null_str(str);
    return string_to_name(str);
}

extern "C" const char* abieos_name_to_string(abieos_context* context, uint64_t name) {
    return handle_exceptions(context, nullptr, [&] {
        context->result_str = name_to_string(name);
        return context->result_str.c_str();
    });
}

extern "C" abieos_bool abieos_set_abi(abieos_context* context, uint64_t contract, const char* abi) {
    fix_null_str(abi);
    return handle_exceptions(context, false, [&] {
        context->last_error = "abi parse error";
        abi_def def{};
        if (!json_to_native(def, abi))
            return false;
        check_abi_version(def.version);
        auto c = create_contract(def);
        context->contracts.insert({name{contract}, std::move(c)});
        return true;
    });
}

extern "C" abieos_bool abieos_set_abi_bin(abieos_context* context, uint64_t contract, const char* data, size_t size) {
    return handle_exceptions(context, false, [&] {
        context->last_error = "abi parse error";
        if (!data || !size)
            throw std::runtime_error("no data");
        check_abi_version(input_buffer{data, data + size});
        abi_def def{};
        if (!bin_to_native(def, {data, data + size}))
            return false;
        auto c = create_contract(def);
        context->contracts.insert({name{contract}, std::move(c)});
        return true;
    });
}

extern "C" abieos_bool abieos_set_abi_hex(abieos_context* context, uint64_t contract, const char* hex) {
    fix_null_str(hex);
    return handle_exceptions(context, false, [&] {
        std::vector<char> data;
        boost::algorithm::unhex(hex, hex + strlen(hex), std::back_inserter(data));
        return abieos_set_abi_bin(context, contract, data.data(), data.size());
    });
}

extern "C" const char* abieos_get_type_for_action(abieos_context* context, uint64_t contract, uint64_t action) {
    return handle_exceptions(context, nullptr, [&] {
        auto contract_it = context->contracts.find(::abieos::name{contract});
        if (contract_it == context->contracts.end())
            throw std::runtime_error("contract \"" + name_to_string(contract) + "\" is not loaded");
        auto& c = contract_it->second;

        auto action_it = c.action_types.find(name{action});
        if (action_it == c.action_types.end())
            throw std::runtime_error("contract \"" + name_to_string(contract) + "\" does not have action \"" +
                                     name_to_string(action) + "\"");
        return action_it->second.c_str();
    });
}

extern "C" abieos_bool abieos_json_to_bin(abieos_context* context, uint64_t contract, const char* type,
                                          const char* json) {
    fix_null_str(type);
    fix_null_str(json);
    return handle_exceptions(context, false, [&] {
        context->last_error = "json parse error";
        auto contract_it = context->contracts.find(::abieos::name{contract});
        if (contract_it == context->contracts.end())
            throw std::runtime_error("contract \"" + name_to_string(contract) + "\" is not loaded");
        auto& t = get_type(contract_it->second.abi_types, type, 0);
        context->result_bin.clear();
        return json_to_bin(context->result_bin, &t, json);
    });
}

extern "C" abieos_bool abieos_json_to_bin_reorderable(abieos_context* context, uint64_t contract, const char* type,
                                                      const char* json) {
    fix_null_str(type);
    fix_null_str(json);
    return handle_exceptions(context, false, [&] {
        context->last_error = "json parse error";
        auto contract_it = context->contracts.find(::abieos::name{contract});
        if (contract_it == context->contracts.end())
            throw std::runtime_error("contract \"" + name_to_string(contract) + "\" is not loaded");
        auto& t = get_type(contract_it->second.abi_types, type, 0);
        context->result_bin.clear();
        ::abieos::jvalue value;
        if (!json_to_jvalue(value, json))
            return false;
        auto result = json_to_bin(context->result_bin, &t, value);
        return result;
    });
}

extern "C" const char* abieos_bin_to_json(abieos_context* context, uint64_t contract, const char* type,
                                          const char* data, size_t size) {
    fix_null_str(type);
    return handle_exceptions(context, nullptr, [&]() -> const char* {
        if (!data)
            size = 0;
        context->last_error = "binary decode error";
        auto contract_it = context->contracts.find(::abieos::name{contract});
        if (contract_it == context->contracts.end())
            throw std::runtime_error("contract \"" + name_to_string(contract) + "\" is not loaded");
        auto& t = get_type(contract_it->second.abi_types, type, 0);
        input_buffer bin{data, data + size};
        if (!bin_to_json(bin, &t, context->result_str))
            return nullptr;
        if (bin.pos != bin.end)
            throw std::runtime_error("Extra data");
        return context->result_str.c_str();
    });
}

extern "C" const char* abieos_hex_to_json(abieos_context* context, uint64_t contract, const char* type,
                                          const char* hex) {
    fix_null_str(hex);
    return handle_exceptions(context, nullptr, [&]() -> const char* {
        std::vector<char> data;
        boost::algorithm::unhex(hex, hex + strlen(hex), std::back_inserter(data));
        return abieos_bin_to_json(context, contract, type, data.data(), data.size());
    });
}
