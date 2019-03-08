#pragma once

#include "abieos.h"
#include <string.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"

enum fuzzer_operation {
    fuzzer_json_to_bin,
    fuzzer_hex_to_json,
};

struct fuzzer_header {
    uint8_t abi_is_bin;
    uint8_t operation;
    uint64_t contract;
    uint32_t abi_size;
    uint32_t type_size;
};
#pragma clang diagnostic pop
