//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: MyProcess.cpp
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
#include "MyProcess.h"
#include "MyProcess_private.h"

// System initialize for referenced model: 'MyProcess'
void MyProcess_Init(RT_MODEL_MyProcess_T * const MyProcess_M)
{
  (void) (MyProcess_M);
}

// Start for referenced model: 'MyProcess'
void MyProcess_Start(RT_MODEL_MyProcess_T *const MyProcess_M, const real_T
                     *rtu_In1, real_T *rty_Out2)
{
  MyProcess_M->MyProcess_extInport.rtu_In1 = rtu_In1;
  MyProcess_M->MyProcess_extOutport.rty_Out2 = rty_Out2;
}

// Output and update for referenced model: 'MyProcess'
void MyProcess_fun(RT_MODEL_MyProcess_T * const MyProcess_M)
{
  real_T rtb_TmpLatchAtIn1Outport1;

  // Outputs for Function Call SubSystem: '<Root>/Function-Call Subsystem'
  // SignalConversion generated from: '<S1>/In1'
  rtb_TmpLatchAtIn1Outport1 = *MyProcess_M->MyProcess_extInport.rtu_In1;

  // Gain: '<S1>/Gain'
  *MyProcess_M->MyProcess_extOutport.rty_Out2 = 3.0 * rtb_TmpLatchAtIn1Outport1;

  // End of Outputs for SubSystem: '<Root>/Function-Call Subsystem'
}

// Model initialize function
void MyProcess_initialize(const char_T **rt_errorStatus, RT_MODEL_MyProcess_T *
  const MyProcess_M)
{
  // Registration code
  {
    // initialize error status
    rtmSetErrorStatusPointer(MyProcess_M, rt_errorStatus);
  }
}

//
// File trailer for generated code.
//
// [EOF]
//
