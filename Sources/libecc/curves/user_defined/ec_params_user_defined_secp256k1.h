#include "../../lib_ecc_config.h"
#ifdef WITH_CURVE_USER_DEFINED_SECP256K1

#ifndef __EC_PARAMS_USER_DEFINED_SECP256K1_H__
#define __EC_PARAMS_USER_DEFINED_SECP256K1_H__
#include "../known/ec_params_external.h"
static const u8 user_defined_secp256k1_p[] = {
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xfc, 0x2f, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p);

#define CURVE_USER_DEFINED_SECP256K1_P_BITLEN 256
static const u8 user_defined_secp256k1_p_bitlen[] = {
	0x01, 0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_bitlen);

#if (WORD_BYTES == 8)     /* 64-bit words */
static const u8 user_defined_secp256k1_r[] = {
	0x01, 0x00, 0x00, 0x03, 0xd1, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_r);

static const u8 user_defined_secp256k1_r_square[] = {
	0x01, 0x00, 0x00, 0x07, 0xa2, 0x00, 0x0e, 0x90, 
	0xa1, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_r_square);

static const u8 user_defined_secp256k1_mpinv[] = {
	0xd8, 0x38, 0x09, 0x1d, 0xd2, 0x25, 0x35, 0x31, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_mpinv);

static const u8 user_defined_secp256k1_p_shift[] = {
	0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_shift);

static const u8 user_defined_secp256k1_p_normalized[] = {
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xfc, 0x2f, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_normalized);

static const u8 user_defined_secp256k1_p_reciprocal[] = {
	0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_reciprocal);

#elif (WORD_BYTES == 4)   /* 32-bit words */
static const u8 user_defined_secp256k1_r[] = {
	0x01, 0x00, 0x00, 0x03, 0xd1, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_r);

static const u8 user_defined_secp256k1_r_square[] = {
	0x01, 0x00, 0x00, 0x07, 0xa2, 0x00, 0x0e, 0x90, 
	0xa1, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_r_square);

static const u8 user_defined_secp256k1_mpinv[] = {
	0xd2, 0x25, 0x35, 0x31, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_mpinv);

static const u8 user_defined_secp256k1_p_shift[] = {
	0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_shift);

static const u8 user_defined_secp256k1_p_normalized[] = {
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xfc, 0x2f, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_normalized);

static const u8 user_defined_secp256k1_p_reciprocal[] = {
	0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_reciprocal);

#elif (WORD_BYTES == 2)   /* 16-bit words */
static const u8 user_defined_secp256k1_r[] = {
	0x01, 0x00, 0x00, 0x03, 0xd1, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_r);

static const u8 user_defined_secp256k1_r_square[] = {
	0x01, 0x00, 0x00, 0x07, 0xa2, 0x00, 0x0e, 0x90, 
	0xa1, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_r_square);

static const u8 user_defined_secp256k1_mpinv[] = {
	0x35, 0x31, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_mpinv);

static const u8 user_defined_secp256k1_p_shift[] = {
	0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_shift);

static const u8 user_defined_secp256k1_p_normalized[] = {
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xfc, 0x2f, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_normalized);

static const u8 user_defined_secp256k1_p_reciprocal[] = {
	0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_p_reciprocal);

#else                     /* unknown word size */
#error "Unsupported word size"
#endif

static const u8 user_defined_secp256k1_a[] = {
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_a);

static const u8 user_defined_secp256k1_b[] = {
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_b);

static const u8 user_defined_secp256k1_npoints[] = {
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 
	0xba, 0xae, 0xdc, 0xe6, 0xaf, 0x48, 0xa0, 0x3b, 
	0xbf, 0xd2, 0x5e, 0x8c, 0xd0, 0x36, 0x41, 0x41, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_npoints);

static const u8 user_defined_secp256k1_gx[] = {
	0x79, 0xbe, 0x66, 0x7e, 0xf9, 0xdc, 0xbb, 0xac, 
	0x55, 0xa0, 0x62, 0x95, 0xce, 0x87, 0x0b, 0x07, 
	0x02, 0x9b, 0xfc, 0xdb, 0x2d, 0xce, 0x28, 0xd9, 
	0x59, 0xf2, 0x81, 0x5b, 0x16, 0xf8, 0x17, 0x98, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_gx);

static const u8 user_defined_secp256k1_gy[] = {
	0x48, 0x3a, 0xda, 0x77, 0x26, 0xa3, 0xc4, 0x65, 
	0x5d, 0xa4, 0xfb, 0xfc, 0x0e, 0x11, 0x08, 0xa8, 
	0xfd, 0x17, 0xb4, 0x48, 0xa6, 0x85, 0x54, 0x19, 
	0x9c, 0x47, 0xd0, 0x8f, 0xfb, 0x10, 0xd4, 0xb8, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_gy);

static const u8 user_defined_secp256k1_gz[] = {
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_gz);

static const u8 user_defined_secp256k1_order[] = {
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 
	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 
	0xba, 0xae, 0xdc, 0xe6, 0xaf, 0x48, 0xa0, 0x3b, 
	0xbf, 0xd2, 0x5e, 0x8c, 0xd0, 0x36, 0x41, 0x41, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_order);

#define CURVE_USER_DEFINED_SECP256K1_Q_BITLEN 256
static const u8 user_defined_secp256k1_order_bitlen[] = {
	0x01, 0x00, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_order_bitlen);

static const u8 user_defined_secp256k1_cofactor[] = {
	0x01, 
};

TO_EC_STR_PARAM(user_defined_secp256k1_cofactor);

static const u8 user_defined_secp256k1_name[] = "USER_DEFINED_SECP256K1";
TO_EC_STR_PARAM(user_defined_secp256k1_name);

static const u8 user_defined_secp256k1_oid[] = "";
TO_EC_STR_PARAM(user_defined_secp256k1_oid);

static const ec_str_params user_defined_secp256k1_str_params = {
	.p = &user_defined_secp256k1_p_str_param, 
	.p_bitlen = &user_defined_secp256k1_p_bitlen_str_param, 
	.r = &user_defined_secp256k1_r_str_param, 
	.r_square = &user_defined_secp256k1_r_square_str_param, 
	.mpinv = &user_defined_secp256k1_mpinv_str_param, 
	.p_shift = &user_defined_secp256k1_p_shift_str_param, 
	.p_normalized = &user_defined_secp256k1_p_normalized_str_param, 
	.p_reciprocal = &user_defined_secp256k1_p_reciprocal_str_param, 
	.a = &user_defined_secp256k1_a_str_param, 
	.b = &user_defined_secp256k1_b_str_param, 
	.npoints = &user_defined_secp256k1_npoints_str_param, 
	.gx = &user_defined_secp256k1_gx_str_param, 
	.gy = &user_defined_secp256k1_gy_str_param, 
	.gz = &user_defined_secp256k1_gz_str_param, 
	.order = &user_defined_secp256k1_order_str_param, 
	.order_bitlen = &user_defined_secp256k1_order_bitlen_str_param, 
	.cofactor = &user_defined_secp256k1_cofactor_str_param, 
	.oid = &user_defined_secp256k1_oid_str_param, 
	.name = &user_defined_secp256k1_name_str_param, 
};

/*
 * Compute max bit length of all curves for p and q
 */
#ifndef CURVES_MAX_P_BIT_LEN
#define CURVES_MAX_P_BIT_LEN    0
#endif
#if (CURVES_MAX_P_BIT_LEN < CURVE_USER_DEFINED_SECP256K1_P_BITLEN)
#undef CURVES_MAX_P_BIT_LEN
#define CURVES_MAX_P_BIT_LEN CURVE_USER_DEFINED_SECP256K1_P_BITLEN
#endif
#ifndef CURVES_MAX_Q_BIT_LEN
#define CURVES_MAX_Q_BIT_LEN    0
#endif
#if (CURVES_MAX_Q_BIT_LEN < CURVE_USER_DEFINED_SECP256K1_Q_BITLEN)
#undef CURVES_MAX_Q_BIT_LEN
#define CURVES_MAX_Q_BIT_LEN CURVE_USER_DEFINED_SECP256K1_Q_BITLEN
#endif

/*
 * Compute and adapt max name and oid length
 */
#ifndef MAX_CURVE_OID_LEN
#define MAX_CURVE_OID_LEN 0
#endif
#ifndef MAX_CURVE_NAME_LEN
#define MAX_CURVE_NAME_LEN 0
#endif
#if (MAX_CURVE_OID_LEN < 1)
#undef MAX_CURVE_OID_LEN
#define MAX_CURVE_OID_LEN 1
#endif
#if (MAX_CURVE_NAME_LEN < 23)
#undef MAX_CURVE_NAME_LEN
#define MAX_CURVE_NAME_LEN 23
#endif

#endif /* __EC_PARAMS_USER_DEFINED_SECP256K1_H__ */

#endif /* WITH_CURVE_USER_DEFINED_SECP256K1 */
