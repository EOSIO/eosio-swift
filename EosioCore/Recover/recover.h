
#ifndef LIBBASE58_H
#define LIBBASE58_H

#include <stdbool.h>
#include <stddef.h>
#include <openssl/ecdsa.h>
#include <openssl/bn.h>




#endif



int ECDSA_SIG_recover_key_GFp(EC_KEY *eckey, ECDSA_SIG *ecsig, const unsigned char *msg, int msglen, int recid, int check);


