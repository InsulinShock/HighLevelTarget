/*
 * Prerelease License - for engineering feedback and testing purposes
 * only. Not for sale.
 * File: _coder_fun1_api.h
 *
 * MATLAB Coder version            : 5.0
 * C/C++ source code generated on  : 09-Jan-2020 23:46:58
 */

#ifndef _CODER_FUN1_API_H
#define _CODER_FUN1_API_H

/* Include Files */
#include <stddef.h>
#include <stdlib.h>
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void fun1(real_T inputArg1, real_T inputArg2, real_T *outputArg1, real_T *
                 outputArg2);
extern void fun1_api(const mxArray * const prhs[2], int32_T nlhs, const mxArray *
                     plhs[2]);
extern void fun1_atexit(void);
extern void fun1_initialize(void);
extern void fun1_terminate(void);
extern void fun1_xil_shutdown(void);
extern void fun1_xil_terminate(void);

#endif

/*
 * File trailer for _coder_fun1_api.h
 *
 * [EOF]
 */
