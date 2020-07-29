#pragma once

#include <array>
#include <cstdint>
#include <optional>
#include <string>
#include <variant>
#include <vector>

namespace eosio {

constexpr const char* get_type_name(bool*) { return "bool"; }
constexpr const char* get_type_name(std::int8_t*) { return "int8"; }
constexpr const char* get_type_name(std::uint8_t*) { return "uint8"; }
constexpr const char* get_type_name(std::int16_t*) { return "int16"; }
constexpr const char* get_type_name(std::uint16_t*) { return "uint16"; }
constexpr const char* get_type_name(std::int32_t*) { return "int32"; }
constexpr const char* get_type_name(std::uint32_t*) { return "uint32"; }
constexpr const char* get_type_name(std::int64_t*) { return "int64"; }
constexpr const char* get_type_name(std::uint64_t*) { return "uint64"; }
constexpr const char* get_type_name(float*) { return "float32"; }
constexpr const char* get_type_name(double*) { return "float64"; }
constexpr const char* get_type_name(std::string*) { return "string"; }

#ifndef ABIEOS_NO_INT128
constexpr const char* get_type_name(__int128*) { return "int128"; }
constexpr const char* get_type_name(unsigned __int128*) { return "uint128"; }
#endif

#ifdef __eosio_cdt__
constexpr const char* get_type_name(long double*) { return "float128"; }
#endif

template <std::size_t N, std::size_t M>
constexpr std::array<char, N + M> array_cat(std::array<char, N> lhs, std::array<char, M> rhs) {
   std::array<char, N + M> result{};
   for (int i = 0; i < N; ++i) { result[i] = lhs[i]; }
   for (int i = 0; i < M; ++i) { result[i + N] = rhs[i]; }
   return result;
}

template <std::size_t N>
constexpr std::array<char, N> to_array(std::string_view s) {
   std::array<char, N> result{};
   for (int i = 0; i < N; ++i) { result[i] = s[i]; }
   return result;
}

template <typename T, std::size_t N>
constexpr auto append_type_name(const char (&suffix)[N]) {
   constexpr std::string_view name = get_type_name((T*)nullptr);
   return array_cat(to_array<name.size()>(name), to_array<N>({ suffix, N }));
}

template <typename T>
constexpr auto vector_type_name = append_type_name<T>("[]");

template <typename T>
constexpr auto optional_type_name = append_type_name<T>("?");

template <typename T>
constexpr const char* get_type_name(std::vector<T>*) {
   return vector_type_name<T>.data();
}

template <typename T>
constexpr const char* get_type_name(std::optional<T>*) {
   return optional_type_name<T>.data();
}

struct variant_type_appender {
   char*                           buf;
   constexpr variant_type_appender operator+(std::string_view s) {
      *buf++ = '_';
      for (auto ch : s) *buf++ = ch;
      return *this;
   }
};

template <typename... T>
constexpr auto get_variant_type_name() {
   constexpr std::size_t  size = sizeof("variant") + ((std::string_view(get_type_name((T*)nullptr)).size() + 1) + ...);
   std::array<char, size> buffer{ 'v', 'a', 'r', 'i', 'a', 'n', 't' };
   (variant_type_appender{ buffer.data() + 7 } + ... + std::string_view(get_type_name((T*)nullptr)));
   buffer[buffer.size() - 1] = '\0';
   return buffer;
}

template <typename... T>
constexpr auto variant_type_name = get_variant_type_name<T...>();

template <typename... T>
constexpr const char* get_type_name(std::variant<T...>*) {
   return variant_type_name<T...>.data();
}

} // namespace eosio
