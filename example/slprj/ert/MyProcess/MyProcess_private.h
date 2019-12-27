//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: MyProcess_private.h
//
// Code generated for Simulink model 'MyProcess'.
//
// Model version                  : 1.6
// Simulink Coder version         : 9.3 (R2020a) 18-Nov-2019
// C/C++ source code generated on : Mon Dec 23 08:57:00 2019
//
// Target selection: ert.tlc
// Embedded hardware selection: Intel->x86-64 (Windows64)
// Code generation objectives: Unspecified
// Validation result: Not run
//
#ifndef RTW_HEADER_MyProcess_private_h_
#define RTW_HEADER_MyProcess_private_h_
#include "rtwtypes.h"
#include "MyProcess.h"

// Macros for accessing real-time model data structure
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        (*((rtm)->errorStatus))
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   (*((rtm)->errorStatus) = (val))
#endif

#ifndef rtmGetErrorStatusPointer
# define rtmGetErrorStatusPointer(rtm) (rtm)->errorStatus
#endif

#ifndef rtmSetErrorStatusPointer
# define rtmSetErrorStatusPointer(rtm, val) ((rtm)->errorStatus = (val))
#endif
#endif                                 // RTW_HEADER_MyProcess_private_h_

//
// File trailer for generated code.
//
// [EOF]
//
