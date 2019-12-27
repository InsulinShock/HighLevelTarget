//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: model0.cpp
//
// Code generated for Simulink model 'model0'.
//
// Model version                  : 1.13
// Simulink Coder version         : 9.3 (R2020a) 18-Nov-2019
// C/C++ source code generated on : Mon Dec 23 09:03:17 2019
//
// Target selection: ert.tlc
// Embedded hardware selection: Intel->x86-64 (Windows64)
// Code generation objectives: Unspecified
// Validation result: Not run
//
#include "model0.h"
#include "model0_private.h"

// Model step function
void model0ModelClass::fun()
{
  // RootInportFunctionCallGenerator generated from: '<Root>/fun' incorporates:
  //   SubSystem: '<Root>/Function-Call Subsystem'

  // Outport: '<Root>/Out2' incorporates:
  //   Gain: '<S1>/Gain'
  //   Inport: '<Root>/In1'

  model0_Y.Out2 = 3.0 * model0_U.In1;

  // End of Outputs for RootInportFunctionCallGenerator generated from: '<Root>/fun' 
}

// Model initialize function
void model0ModelClass::initialize()
{
  // (no initialization code required)
}

// Model terminate function
void model0ModelClass::terminate()
{
  // (no terminate code required)
}

// Constructor
model0ModelClass::model0ModelClass():
  model0_U()
  ,model0_Y()
  ,model0_M()
{
  // Currently there is no constructor body generated.
}

// Destructor
model0ModelClass::~model0ModelClass()
{
  // Currently there is no destructor body generated.
}

// Real-Time Model get method
model0ModelClass::RT_MODEL_model0_T * model0ModelClass::getRTM()
{
  return (&model0_M);
}

//
// File trailer for generated code.
//
// [EOF]
//
