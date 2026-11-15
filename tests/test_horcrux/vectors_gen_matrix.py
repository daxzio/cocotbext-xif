"""Golden vectors from gen-matrix/main.c."""
TEST_SEED = bytes(range(32))

GEN_A_GOLDEN = {
    (0, 0): [1364, 199, 712, 506],
    (0, 1): [483, 1189, 1089, 2233],
    (1, 0): [536, 843, 1994, 2664],
    (1, 1): [314, 1867, 3116, 2581],
}

GEN_AT_GOLDEN = {
    (0, 0): [1364, 199, 712, 506],
    (0, 1): [536, 843, 1994, 2664],
    (1, 0): [483, 1189, 1089, 2233],
    (1, 1): [314, 1867, 3116, 2581],
}

KYBER_Q = 3329
KYBER_N = 256
SHAKE128_RATE = 168
XOF_BLOCKBYTES = 168
GEN_MATRIX_NBLOCKS = 3
