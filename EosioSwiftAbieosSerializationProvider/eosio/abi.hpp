#pragma once

#include <functional>
#include <string>
#include <map>
#include <vector>
#include <variant>
#include "types.hpp"
#include "name.hpp"

namespace eosio {

enum class abi_error {
   no_error,

   recursion_limit_reached,
   invalid_nesting,
   unknown_type,
   missing_name,
   redefined_type,
   base_not_a_struct,
   extension_typedef,
   bad_abi
};

constexpr inline std::string_view convert_abi_error(eosio::abi_error e) {
   switch(e) {
      case abi_error::no_error: return "No error";
      case abi_error::recursion_limit_reached: return "Recursion limit reached";
      case abi_error::invalid_nesting: return "Invalid nesting";
      case abi_error::unknown_type: return "Unknown type";
      case abi_error::missing_name: return "Missing name";
      case abi_error::redefined_type: return "Redefined type";
      case abi_error::base_not_a_struct: return "Base not a struct";
      case abi_error::extension_typedef: return "Extension typedef";
      case abi_error::bad_abi: return "Bad ABI";
      default: return "internal failure";
   };
}

struct abi_serializer;

template <typename T>
struct might_not_exist {
    T value{};
};

template <typename T, typename S>
void from_bin(might_not_exist<T>& obj, S& stream) {
    if (stream.remaining())
        return from_bin(obj.value, stream);
}

template <typename T, typename S>
void from_json(might_not_exist<T>& obj, S& stream) {
    return from_json(obj.value, stream);
}

using abi_extensions_type = std::vector<std::pair<uint16_t, std::vector<char>>>;

struct type_def {
    std::string new_type_name{};
    std::string type{};
};

EOSIO_REFLECT(type_def, new_type_name, type);

struct field_def {
    std::string name{};
    std::string type{};
};

EOSIO_REFLECT(field_def, name, type);

struct struct_def {
    std::string name{};
    std::string base{};
    std::vector<field_def> fields{};
};

EOSIO_REFLECT(struct_def, name, base, fields);

struct action_def {
    eosio::name name{};
    std::string type{};
    std::string ricardian_contract{};
};

EOSIO_REFLECT(action_def, name, type, ricardian_contract);

struct table_def {
    eosio::name name{};
    std::string index_type{};
    std::vector<std::string> key_names{};
    std::vector<std::string> key_types{};
    std::string type{};
};

EOSIO_REFLECT(table_def, name, index_type, key_names, key_types, type);

struct clause_pair {
    std::string id{};
    std::string body{};
};

EOSIO_REFLECT(clause_pair, id, body);

struct error_message {
    uint64_t error_code{};
    std::string error_msg{};
};

EOSIO_REFLECT(error_message, error_code, error_msg);

struct variant_def {
    std::string name{};
    std::vector<std::string> types{};
};

EOSIO_REFLECT(variant_def, name, types);

struct abi_def {
    std::string version{};
    std::vector<type_def> types{};
    std::vector<struct_def> structs{};
    std::vector<action_def> actions{};
    std::vector<table_def> tables{};
    std::vector<clause_pair> ricardian_clauses{};
    std::vector<error_message> error_messages{};
    abi_extensions_type abi_extensions{};
    might_not_exist<std::vector<variant_def>> variants{};
};

EOSIO_REFLECT(abi_def, version, types, structs, actions, tables, ricardian_clauses, error_messages, abi_extensions,
              variants);

struct abi_type;

struct abi_field {
    std::string name;
    const abi_type* type;
};

struct abi_type {
    std::string name;

    struct builtin {};
    using alias_def = std::string;
    struct alias { abi_type* type; };
    struct optional { abi_type* type; };
    struct extension { abi_type* type; };
    struct array { abi_type* type; };
    struct struct_ {
        abi_type* base = nullptr;
        std::vector<abi_field> fields;
    };
    using variant = std::vector<abi_field>;
    std::variant<builtin, const alias_def*, const struct_def*, const variant_def*, alias, optional, extension, array, struct_, variant> _data;
    const abi_serializer* ser = nullptr;

    template<typename T>
    abi_type(std::string name, T&& arg, const abi_serializer* ser)
        : name(std::move(name)), _data(std::forward<T>(arg)), ser(ser) {}
    abi_type(const abi_type&) = delete;
    abi_type& operator=(const abi_type&) = delete;

    // result<void> json_to_bin(std::vector<char>& bin, std::string_view json);
    const abi_type* optional_of() const {
       if(auto* t = std::get_if<optional>(&_data)) return t->type;
       else return nullptr;
    }
    const abi_type* extension_of() const {
       if(auto* t = std::get_if<extension>(&_data)) return t->type;
       else return nullptr;
    }
    const abi_type* array_of() const {
       if(auto* t = std::get_if<array>(&_data)) return t->type;
       else return nullptr;
    }
    const struct_* as_struct() const {
       return std::get_if<struct_>(&_data);
    }
    const variant* as_variant() const {
       return std::get_if<variant>(&_data);
    }

    std::string bin_to_json(input_stream& bin, std::function<void()> f = []{}) const;
    std::vector<char> json_to_bin(std::string_view json, std::function<void()> f = []{}) const;
    std::vector<char> json_to_bin_reorderable(std::string_view json, std::function<void()> f = []{}) const;
};

struct abi {
    std::map<eosio::name, std::string> action_types;
    std::map<eosio::name, std::string> table_types;
    std::map<std::string, abi_type> abi_types;
    const abi_type* get_type(const std::string& name);

    // Adds a type to the abi.  Has no effect if the type is already present.
    // If the type is a struct, all members will be added recursively.
    // Exception Safety: basic. If add_type fails, some objects may have
    // an incomplete list of fields.
    template<typename T>
    abi_type* add_type();
};

void convert(const abi_def& def, abi&);
void convert(const abi& def, abi_def&);

extern const abi_serializer* const object_abi_serializer;
extern const abi_serializer* const variant_abi_serializer;
extern const abi_serializer* const array_abi_serializer;
extern const abi_serializer* const extension_abi_serializer;
extern const abi_serializer* const optional_abi_serializer;

template<typename T>
auto add_type(abi& a, T*) -> std::enable_if_t<reflection::has_for_each_field_v<T>, abi_type*> {
   std::string name = get_type_name((T*)nullptr);
   auto [iter, inserted] = a.abi_types.try_emplace(name, name, abi_type::struct_{}, object_abi_serializer);
   if(!inserted)
      return &iter->second;
   auto& s = std::get<abi_type::struct_>(iter->second._data);
   for_each_field<T>([&](const char* name, auto&& member){
      auto member_type = a.add_type<std::decay_t<decltype(member((T*)nullptr))>>();
      s.fields.push_back({name, member_type});
   });
   return &iter->second;
}

template<typename T>
auto add_type(abi& a, T* t) -> std::enable_if_t<!reflection::has_for_each_field_v<T>, abi_type*> {
   auto iter = a.abi_types.find(get_type_name(t));
   check( iter != a.abi_types.end(),
      convert_abi_error(abi_error::unknown_type) );
   return &iter->second;
}

template<typename T>
abi_type* add_type(abi& a, std::vector<T>*) {
   auto element_type = a.add_type<T>();
   check(!(element_type->optional_of() || element_type->array_of() || element_type->extension_of()),
      convert_abi_error(abi_error::invalid_nesting));
   std::string name = get_type_name((std::vector<T>*)nullptr);
   auto [iter, inserted] = a.abi_types.try_emplace(name, name, abi_type::array{element_type}, array_abi_serializer);
   return &iter->second;
}

template<typename... T>
abi_type* add_type(abi& a, std::variant<T...>*) {
   abi_type::variant types;
   ([&](auto* t) {
      auto type = add_type(a, t);
      types.push_back({type->name, type});
   }((T*)nullptr), ...);
   std::string name = get_type_name((std::variant<T...>*)nullptr);

   auto [iter, inserted] = a.abi_types.try_emplace(name, name, std::move(types), variant_abi_serializer);
   return &iter->second;
}

template<typename T>
abi_type* add_type(abi& a, std::optional<T>*) {
   auto element_type = a.add_type<T>();
   check(!(element_type->optional_of() || element_type->array_of() || element_type->extension_of()),
      convert_abi_error(abi_error::invalid_nesting));
   std::string name = get_type_name((std::optional<T>*)nullptr);
   auto [iter, inserted] = a.abi_types.try_emplace(name, name, abi_type::optional{element_type}, optional_abi_serializer);
   return &iter->second;
}

template<typename T>
abi_type* add_type(abi& a, might_not_exist<T>*) {
   auto element_type = a.add_type<T>();
   check(!element_type->extension_of(),
      convert_abi_error(abi_error::invalid_nesting));
   std::string name = element_type->name + "$";
   auto [iter, inserted] = a.abi_types.try_emplace(name, name, abi_type::extension{element_type}, extension_abi_serializer);
   return &iter->second;
}

template<typename T>
abi_type* abi::add_type() {
   using eosio::add_type;
   return add_type(*this, (T*)nullptr);
}

}
