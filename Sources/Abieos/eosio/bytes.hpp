#pragma once

#include "from_json.hpp"
#include "to_json.hpp"
#include "operators.hpp"
#include <vector>

namespace eosio {

struct bytes {
   std::vector<char> data;
};

EOSIO_REFLECT(bytes, data);
EOSIO_COMPARE(bytes);

template <typename S>
void from_json(bytes& obj, S& stream) {
   return eosio::from_json_hex(obj.data, stream);
}

template <typename S>
void to_json(const bytes& obj, S& stream) {
   return eosio::to_json_hex(obj.data.data(), obj.data.size(), stream);
}

} // namespace eosio
