#include <stdexcept>

namespace abieos {

struct error : std::exception {
    std::string message;

    error(std::string message) : message(std::move(message)) {}
    virtual const char* what() const noexcept { return message.c_str(); }
};

} // namespace abieos
