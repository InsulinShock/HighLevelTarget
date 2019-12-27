//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: MyProcess.h
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
#ifndef RTW_HEADER_MyProcess_h_
#define RTW_HEADER_MyProcess_h_
#include "rtwtypes.h"
#include "MyProcess_types.h"

// external outport data, for model 'MyProcess'
typedef struct {
  real_T* rty_Out2;
} extOutport_MyProcess_T;

// external inport data, for model 'MyProcess'
typedef struct {
  const real_T* rtu_In1;
} extInport_MyProcess_T;

// Self model data, for model 'MyProcess'
struct tag_RTM_MyProcess_T {
  const char_T **errorStatus;
  extInport_MyProcess_T MyProcess_extInport;
  extOutport_MyProcess_T MyProcess_extOutport;
};

// Model reference registration function
extern void MyProcess_initialize(const char_T **rt_errorStatus,
  RT_MODEL_MyProcess_T *const MyProcess_M);
extern void MyProcess_Init(RT_MODEL_MyProcess_T * const MyProcess_M);
extern void MyProcess_fun(RT_MODEL_MyProcess_T * const MyProcess_M);
extern void MyProcess_Start(RT_MODEL_MyProcess_T *const MyProcess_M, const
  real_T *rtu_In1, real_T *rty_Out2);

//-
//  The generated code includes comments that allow you to trace directly
//  back to the appropriate location in the model.  The basic format
//  is <system>/block_name, where system is the system number (uniquely
//  assigned by Simulink) and block_name is the name of the block.
//
//  Use the MATLAB hilite_system command to trace the generated code back
//  to the model.  For example,
//
//  hilite_system('<S3>')    - opens system 3
//  hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
//
//  Here is the system hierarchy for this model
//
//  '<Root>' : 'MyProcess'
//  '<S1>'   : 'MyProcess/Function-Call Subsystem'

#endif                                 // RTW_HEADER_MyProcess_h_

//
// File trailer for generated code.
//
// [EOF]
//
