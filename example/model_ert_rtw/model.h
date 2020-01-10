//
// Prerelease License - for engineering feedback and testing purposes
// only. Not for sale.
//
// File: model.h
//
// Code generated for Simulink model 'model'.
//
// Model version                  : 1.6
// Simulink Coder version         : 9.3 (R2020a) 18-Nov-2019
// C/C++ source code generated on : Thu Jan  9 18:07:46 2020
//
// Target selection: ert.tlc
// Embedded hardware selection: MyManufacturer->MyDevice
// Code generation objectives: Unspecified
// Validation result: Not run
//
#ifndef RTW_HEADER_model_h_
#define RTW_HEADER_model_h_
#include "rtwtypes.h"
#include "model_types.h"

// Macros for accessing real-time model data structure
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

// Class declaration for model model
class modelModelClass {
  // public data and function members
 public:
  // Real-time Model Data Structure
  struct RT_MODEL_model_T {
    const char_T * volatile errorStatus;
  };

  // model initialize function
  void initialize();

  // model step function
  void step();

  // model terminate function
  void terminate();

  // Constructor
  modelModelClass();

  // Destructor
  ~modelModelClass();

  // Real-Time Model get method
  modelModelClass::RT_MODEL_model_T * getRTM();

  // private data and function members
 private:
  // Real-Time Model
  RT_MODEL_model_T model_M;
};

//-
//  These blocks were eliminated from the model due to optimizations:
//
//  Block '<S1>/Data Type Propagation' : Unused code path elimination
//  Block '<S2>/FixPt Constant' : Unused code path elimination
//  Block '<S2>/FixPt Data Type Duplicate' : Unused code path elimination
//  Block '<S2>/FixPt Sum1' : Unused code path elimination
//  Block '<S1>/Output' : Unused code path elimination
//  Block '<S3>/Constant' : Unused code path elimination
//  Block '<S3>/FixPt Data Type Duplicate1' : Unused code path elimination
//  Block '<S3>/FixPt Switch' : Unused code path elimination
//  Block '<Root>/Gain' : Unused code path elimination


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
//  '<Root>' : 'model'
//  '<S1>'   : 'model/Counter Limited'
//  '<S2>'   : 'model/Counter Limited/Increment Real World'
//  '<S3>'   : 'model/Counter Limited/Wrap To Zero'

#endif                                 // RTW_HEADER_model_h_

//
// File trailer for generated code.
//
// [EOF]
//
