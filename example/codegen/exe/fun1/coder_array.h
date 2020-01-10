/* Copied from fullfile(matlabroot,'extern','include','coder','coder_array','coder_array_rtw.h') */
#pragma once

#ifndef _mw_coder_array_h
#define _mw_coder_array_h

// -------------------------------------------------------------------------------------------------------------------------------------------
//  Usage:
//
//  coder::array<T, N>: T base type of data, N number of dimensions
//
//  coder::array()
//               : default constructor
//  coder::array(const coder::array &)
//               : copy constructor (always make a deep copy of other array)
//  coder::array(const T *data, const int32_T *sz)
//               : Set data with sizes of this array.
//               : (Data is not copied, data is not deleted)
//  coder::array::operator = (coder coder::array &)
//               : Assign into this array;
//               : delete its previous contents (if owning the data.)
//  set(const T *data, int32_T sz1, int32_T sz2, ...)
//               : Set data with dimensions.
//               : (Data is not copied, data is not deleted)
//  set_size(int32_T sz1, int32_T sz2, ...)
//               : Set sizes of array. Reallocate memory of data if needed.
//  bool is_owner() : Return true if the data is owned by the class.
//  void no_free()
//               : The class does no longer owns its data;
//               : data is no longer deleted.
//  int32_T capacity() : How many entries are reserved by memory allocation.
//  reshape( int32_T sz1, int32_T sz2, ...)
//               : Reshape array to a different ND shape. Do not copy the data.
//               : The user must honor the number of elements stay unchanged.
//               : Return the array with possibly new number of dimensions.
//  clear()      : Reset array to be empty.
//  int32_T numel() : Return the number of elements.
//  operator [] (int32_T index) : Extract element at linear index (0 based.)
//  size(int32_T dimension) : Size of array of the provided dimension.
//  int32_T * size_ptr() or size()
//               : Return the pointer to all the sizes of this array.
//  int32_T index(int32_T i1, int32_T i2, ...)
//               : Compute the linear index from ND index (i1,i2,...)
//  at(int32_T i1, int32_T i2, ...) : The element at index (i1,i2,...)
// -------------------------------------------------------------------------------------------------------------------------------------------

#include <vector>
#include <string>
#include <sstream>
#include <iostream>
#include <fstream>
#include <iterator>
#include <cstring>
#include <cassert>

#if defined(BUILDING_UNITTEST)
#include "tmwtypes.h"
#else
#include "rtwtypes.h"
#endif

namespace coder {

#ifndef CODER_ARRAY_NEW_DELETE
#define CODER_ARRAY_NEW_DELETE
#define CODER_NEW(T, N) new T[N]
#define CODER_DELETE(P) delete[](P)
#endif

#ifndef CODER_ARRAY_SIZE_TYPE_DEFINED
typedef int32_T SizeType;
#endif

#ifndef CODER_ARRAY_DATA_PTR_DEFINED
// data_ptr<T,SZ> is an internal class (not to be used by user code.)
// It's a data cointainer (like std::vector) but with the option of
// not owning the data, i.e. when ~data_ptr() is called it won't free
// the underlying data if it's not the owner of it.
template <typename T, typename SZ>
class data_ptr {
  public:
    typedef T value_type;
    typedef SZ size_type;

    inline data_ptr()
        : data_(NULL)
        , size_(0)
        , capacity_(0)
        , owner_(false) {
    }
    inline data_ptr(const T* _data, SZ _sz)
        : data_(const_cast<T*>(_data))
        , size_(_sz)
        , capacity_(_sz)
        , owner_(false) {
    }

    inline data_ptr(const data_ptr& _other)
        : data_(_other.owner_ ? NULL : _other.data_)
        , size_(_other.owner_ ? 0 : _other.size_)
        , capacity_(_other.owner_ ? 0 : _other.capacity_)
        , owner_(_other.owner_) {
        if (owner_) {
            resize(_other.size_);
            std::copy(_other.data_, _other.data_ + size_, data_);
        }
    }

    inline ~data_ptr() {
        if (owner_) {
            CODER_DELETE(data_);
        }
    }
    inline SZ capacity() const {
        return capacity_;
    }
    inline void reserve(SZ _n) {
        if (_n > capacity_) {
            T* new_data = CODER_NEW(T, _n);
            if (size_ != 0) {
                std::copy(data_, data_ + size_, new_data);
            }
            CODER_DELETE(data_);
            data_ = new_data;
            capacity_ = _n;
            owner_ = true;
        }
    }
    inline void resize(SZ _n) {
        reserve(_n);
        size_ = _n;
    }

  private:
    // Prohibit use of assignment operator to prevent subtle bugs
    void operator=(const data_ptr<T, SZ>& _other);

  public:
    inline void set(const T* _data, const SZ _sz) {
        if (data_ != _data) {
            CODER_DELETE(const_cast<T*>(data_));
        }
        data_ = const_cast<T*>(_data);
        size_ = _sz;
        owner_ = false;
        capacity_ = size_;
    }

    inline void copy(const data_ptr<T, SZ>& _other) {
        if (data_ == _other.data_) {
            return;
        }
        CODER_DELETE(data_);
        data_ = CODER_NEW(T, _other.size_);
        owner_ = true;
        size_ = _other.size_;
        capacity_ = size_;
        std::copy(_other.data_, _other.data_ + size_, data_);
    }

    inline operator T*() {
        return &data_[0];
    }

    inline operator const T*() const {
        return &data_[0];
    }

    inline T& operator[](const SZ _index) {
        return data_[_index];
    }
    inline const T& operator[](const SZ _index) const {
        return data_[_index];
    }

    inline T* operator->() {
        return data_;
    }

    inline const T* operator->() const {
        return data_;
    }

    inline bool is_null() const {
        return data_ == NULL;
    }

    inline void clear() {
        CODER_DELETE(data_);
        data_ = NULL;
        size_ = 0;
        capacity_ = 0;
        owner_ = true;
    }

    inline bool is_owner() const {
        return owner_;
    }

    inline void set_owner(bool _b) {
        owner_ = _b;
    }

  private:
    T* data_;
    SZ size_;
    SZ capacity_;
    bool owner_;
};
#endif

// Implementing the random access iterator class so coder::array can be
// used in STL iterators.
template <typename T>
class array_iterator : public std::iterator<std::random_access_iterator_tag,
                                            typename T::value_type,
                                            typename T::size_type> {
  public:
    inline array_iterator(const array_iterator<T>& other)
        : arr_(other.arr_)
        , i_(other.i_)
        , n_(other.n_) {
    }
    inline ~array_iterator() {
    }
    inline typename T::value_type& operator*() {
        return arr_[i_];
    }
    inline typename T::value_type* operator->() {
        return &arr_[i_];
    }
    inline typename T::value_type& operator[](typename T::size_type _di) {
        return arr_[i_ + _di];
    }
    inline array_iterator<T>& operator++() {
        ++i_;
        return *this;
    }
    inline array_iterator<T>& operator--() {
        --i_;
        return *this;
    }
    inline array_iterator<T> operator++(int) {
        array_iterator<T> cp(*this);
        ++i_;
        return cp;
    }
    inline array_iterator<T> operator--(int) {
        array_iterator<T> cp(*this);
        --i_;
        return cp;
    }
    inline array_iterator<T>& operator=(const array_iterator<T>& _other) {
        this->n_ = _other.n_;
        this->i_ = _other.i_;
        return *this;
    }
    inline bool operator==(const array_iterator<T>& _other) const {
        return i_ == _other.i_;
    }
    inline bool operator!=(const array_iterator<T>& _other) const {
        return i_ != _other.i_;
    }
    inline bool operator<(const array_iterator<T>& _other) const {
        return i_ < _other.i_;
    }
    inline bool operator>(const array_iterator<T>& _other) const {
        return i_ > _other.i_;
    }
    inline bool operator<=(const array_iterator<T>& _other) const {
        return i_ <= _other.i_;
    }
    inline bool operator>=(const array_iterator<T>& _other) const {
        return i_ >= _other.i_;
    }
    inline array_iterator<T> operator+(const typename T::size_type _add) const {
        array_iterator<T> cp(*this);
        cp.i_ += _add;
        return cp;
    }
    inline array_iterator<T>& operator+=(const typename T::size_type _add) {
        this->i_ += _add;
        return *this;
    }
    inline array_iterator<T> operator-(const typename T::size_type _subtract) const {
        array_iterator<T> cp(*this);
        cp.i_ -= _subtract;
        return cp;
    }
    inline array_iterator<T>& operator-=(const typename T::size_type _subtract) {
        this->i_ -= _subtract;
        return *this;
    }
    inline typename T::size_type operator-(const array_iterator<T>& _other) const {
        return static_cast<typename T::size_type>(this->i_ - _other.i_);
    }

    inline array_iterator(T& _arr, typename T::size_type _i)
        : arr_(_arr)
        , i_(_i)
        , n_(_arr.numel()) {
    }

  private:
    T& arr_;
    typename T::size_type i_, n_;
};

// Const version of the array iterator.
template <typename T>
class const_array_iterator : public std::iterator<std::random_access_iterator_tag,
                                                  typename T::value_type,
                                                  typename T::size_type> {
  public:
    inline const_array_iterator(const const_array_iterator<T>& other)
        : arr_(other.arr_)
        , i_(other.i_)
        , n_(other.n_) {
    }
    inline ~const_array_iterator() {
    }
    inline const typename T::value_type& operator*() const {
        return arr_[i_];
    }
    inline const typename T::value_type* operator->() const {
        return &arr_[i_];
    }
    inline const typename T::value_type& operator[](typename T::size_type _di) const {
        return arr_[i_ + _di];
    }
    inline const_array_iterator<T>& operator++() {
        ++i_;
        return *this;
    }
    inline const_array_iterator<T>& operator--() {
        --i_;
        return *this;
    }
    inline const_array_iterator<T> operator++(int) {
        const_array_iterator<T> copy(*this);
        ++i_;
        return copy;
    }
    inline const_array_iterator<T> operator--(int) {
        const_array_iterator copy(*this);
        --i_;
        return copy;
    }
    inline const_array_iterator<T>& operator=(const const_array_iterator<T>& _other) {
        this->n_ = _other.n_;
        this->i_ = _other.i_;
        return *this;
    }
    inline bool operator==(const const_array_iterator<T>& _other) const {
        return i_ == _other.i_;
    }
    inline bool operator!=(const const_array_iterator<T>& _other) const {
        return i_ != _other.i_;
    }
    inline bool operator<(const const_array_iterator<T>& _other) const {
        return i_ < _other.i_;
    }
    inline bool operator>(const const_array_iterator<T>& _other) const {
        return i_ > _other.i_;
    }
    inline bool operator<=(const const_array_iterator<T>& _other) const {
        return i_ <= _other.i_;
    }
    inline bool operator>=(const const_array_iterator<T>& _other) const {
        return i_ >= _other.i_;
    }
    inline const_array_iterator<T> operator+(const typename T::size_type _add) const {
        const_array_iterator<T> cp(*this);
        cp.i_ += _add;
        return cp;
    }
    inline const_array_iterator<T>& operator+=(const typename T::size_type _add) {
        this->i_ += _add;
        return *this;
    }
    inline const_array_iterator<T> operator-(const typename T::size_type _subtract) const {
        const_array_iterator<T> cp(*this);
        cp.i_ -= _subtract;
        return cp;
    }

    inline const_array_iterator<T>& operator-=(const typename T::size_type _subtract) {
        this->i_ -= _subtract;
        return *this;
    }

    inline typename T::size_type operator-(const const_array_iterator<T>& _other) const {
        return static_cast<typename T::size_type>(this->i_ - _other.i_);
    }

    inline const_array_iterator(const T& _arr, typename T::size_type _i)
        : arr_(_arr)
        , i_(_i)
        , n_(_arr.numel()) {
    }

  private:
    const T& arr_;
    typename T::size_type i_, n_;
};

// internal_numel<N>: Compile-time product of the given size vector of length N.
template <int32_T N>
class internal_numel {
  public:
    template <typename SZ>
    inline static SZ compute(SZ _size[]) {
        return _size[N - 1] * internal_numel<N - 1>::compute(_size);
    }
};
template <>
class internal_numel<0> {
  public:
    template <typename SZ>
    inline static SZ compute(SZ[]) {
        return 1;
    }
};

// Compute flat index from (column-major) ND size vector and a list of indices.
template <int32_T I>
class internal_index_nd {
  public:
    template <typename SZ>
    inline static SZ compute(const SZ _size[], const SZ _indices[]) {
        const SZ weight = internal_numel<I - 1>::compute(_size);
        return weight * _indices[I - 1] + internal_index_nd<I - 1>::compute(_size, _indices);
    }
};

template <>
class internal_index_nd<0> {
  public:
    template <typename SZ>
    inline static SZ compute(SZ[], SZ[]) {
        return 0;
    }
};

template <bool Cond>
struct match_dimensions {};

template <>
struct match_dimensions<true> {
    inline static void check() {
    }
};

template <>
struct match_dimensions<false> {
    inline static void check() {
        assert(false && "Method with wrong number of dimensions used.");
    }
};

// Base class for code::array. SZ is the type used for sizes (currently int32.)
// Overloading up to 10 dimensions (not using variadic templates it
// stay compatible with C++03.)
template <typename T, typename SZ, int32_T N>
class array_base {
  public:
    typedef T value_type;
    typedef SZ size_type;

    inline array_base() {
        std::memset(size_, 0, sizeof(SZ) * N);
    }

    inline array_base(const T* _data, const SZ* _sz)
        : data_(_data, internal_numel<N>::compute(_sz)) {
        std::copy(_sz, _sz + N, size_);
    }

    inline array_base& operator=(const array_base& _other) {
        data_.copy(_other.data_);
        std::copy(_other.size_, _other.size_ + N, size_);
        return *this;
    }

    inline void set(const T* _data, SZ _n1) {
        match_dimensions<N == 1>::check();
        data_.set(_data, _n1);
        size_[0] = _n1;
    }

    inline void set(const T* _data, SZ _n1, SZ _n2) {
        match_dimensions<N == 2>::check();
        data_.set(_data, _n1 * _n2);
        size_[0] = _n1;
        size_[1] = _n2;
    }

    inline void set(const T* _data, SZ _n1, SZ _n2, SZ _n3) {
        match_dimensions<N == 3>::check();
        data_.set(_data, _n1 * _n2 * _n3);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
    }

    inline void set(const T* _data, SZ _n1, SZ _n2, SZ _n3, SZ _n4) {
        match_dimensions<N == 4>::check();
        data_.set(_data, _n1 * _n2 * _n3 * _n4);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
    }

    inline void set(const T* _data, SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5) {
        match_dimensions<N == 5>::check();
        data_.set(_data, _n1 * _n2 * _n3 * _n4 * _n5);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
    }

    inline void set(const T* _data, SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6) {
        match_dimensions<N == 6>::check();
        data_.set(_data, _n1 * _n2 * _n3 * _n4 * _n5 * _n6);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
    }

    inline void set(const T* _data, SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7) {
        match_dimensions<N == 7>::check();
        data_.set(_data, _n1 * _n2 * _n3 * _n4 * _n5 * _n6 * _n7);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
    }

    inline void
    set(const T* _data, SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8) {
        match_dimensions<N == 8>::check();
        data_.set(_data, _n1 * _n2 * _n3 * _n4 * _n5 * _n6 * _n7 * _n8);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
        size_[7] = _n8;
    }

    inline void
    set(const T* _data, SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8, SZ _n9) {
        match_dimensions<N == 9>::check();
        data_.set(_data, _n1 * _n2 * _n3 * _n4 * _n5 * _n6 * _n7 * _n8 * _n9);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
        size_[7] = _n8;
        size_[8] = _n9;
    }

    inline void set(const T* _data,
                    SZ _n1,
                    SZ _n2,
                    SZ _n3,
                    SZ _n4,
                    SZ _n5,
                    SZ _n6,
                    SZ _n7,
                    SZ _n8,
                    SZ _n9,
                    SZ _n10) {
        match_dimensions<N == 10>::check();
        data_.set(_data, _n1 * _n2 * _n3 * _n4 * _n5 * _n6 * _n7 * _n8 * _n9 * _n10);
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
        size_[7] = _n8;
        size_[8] = _n9;
        size_[9] = _n10;
    }

    inline bool is_owner() const {
        return data_.is_owner();
    }

    inline void no_free() {
        data_.set_owner(false);
    }

    inline SZ capacity() const {
        return data_.capacity();
    }

    inline void set_size(SZ _n1) {
        match_dimensions<N == 1>::check();
        size_[0] = _n1;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2) {
        match_dimensions<N == 2>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2, SZ _n3) {
        match_dimensions<N == 3>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2, SZ _n3, SZ _n4) {
        match_dimensions<N == 4>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5) {
        match_dimensions<N == 5>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6) {
        match_dimensions<N == 6>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7) {
        match_dimensions<N == 7>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8) {
        match_dimensions<N == 8>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
        size_[7] = _n8;
        ensureCapacity(numel());
    }

    inline void set_size(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8, SZ _n9) {
        match_dimensions<N == 9>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
        size_[7] = _n8;
        size_[8] = _n9;
        ensureCapacity(numel());
    }

    inline void
    set_size(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8, SZ _n9, SZ _n10) {
        match_dimensions<N == 10>::check();
        size_[0] = _n1;
        size_[1] = _n2;
        size_[2] = _n3;
        size_[3] = _n4;
        size_[4] = _n5;
        size_[5] = _n6;
        size_[6] = _n7;
        size_[7] = _n8;
        size_[8] = _n9;
        size_[9] = _n10;
        ensureCapacity(numel());
    }

    template <size_t N1>
    inline array_base<T, SZ, N1> reshape_n(const SZ* _ns) const {
        array_base<T, SZ, N1> reshaped(&data_[0], _ns);
        return reshaped;
    }

    inline array_base<T, SZ, 1> reshape(SZ _n1) const {
        const SZ ns[] = {_n1};
        return reshape_n<1>(&ns[0]);
    }

    inline array_base<T, SZ, 2> reshape(SZ _n1, SZ _n2) const {
        const SZ ns[] = {_n1, _n2};
        return reshape_n<2>(&ns[0]);
    }

    inline array_base<T, SZ, 3> reshape(SZ _n1, SZ _n2, SZ _n3) const {
        const SZ ns[] = {_n1, _n2, _n3};
        return reshape_n<3>(&ns[0]);
    }

    inline array_base<T, SZ, 4> reshape(SZ _n1, SZ _n2, SZ _n3, SZ _n4) const {
        const SZ ns[] = {_n1, _n2, _n3, _n4};
        return reshape_n<4>(&ns[0]);
    }

    inline array_base<T, SZ, 5> reshape(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5) const {
        const SZ ns[] = {_n1, _n2, _n3, _n4, _n5};
        return reshape_n<5>(&ns[0]);
    }

    inline array_base<T, SZ, 6> reshape(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6) const {
        const SZ ns[] = {_n1, _n2, _n3, _n4, _n5, _n6};
        return reshape_n<6>(&ns[0]);
    }

    inline array_base<T, SZ, 7> reshape(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7)
        const {
        const SZ ns[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7};
        return reshape_n<7>(&ns[0]);
    }

    inline array_base<T, SZ, 8>
    reshape(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8) const {
        const SZ ns[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7, _n8};
        return reshape_n<8>(&ns[0]);
    }

    inline array_base<T, SZ, 9>
    reshape(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8, SZ _n9) const {
        const SZ ns[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7, _n8, _n9};
        return reshape_n<9>(&ns[0]);
    }

    inline array_base<T, SZ, 10>
    reshape(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8, SZ _n9, SZ _n10) const {
        const SZ ns[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7, _n8, _n9, _n10};
        return reshape_n<10>(&ns[0]);
    }

    inline T& operator[](SZ _index) {
        return data_[_index];
    }

    inline const T& operator[](SZ _index) const {
        return data_[_index];
    }

    inline void clear() {
        data_.clear();
    }

    inline data_ptr<T, SZ>& data() {
        return data_;
    }

    inline const data_ptr<T, SZ>& data() const {
        return data_;
    }

    inline SZ* size_ptr() {
        return &size_[0];
    }

    inline const SZ* size_ptr() const {
        return &size_[0];
    }

    inline SZ* size() {
        return &size_[0];
    }

    inline const SZ* size() const {
        return &size_[0];
    }

    inline SZ size(SZ _index) const {
        return size_[_index];
    }

    inline SZ numel() const {
        return internal_numel<N>::compute(size_);
    }

    inline SZ index(SZ _n1) const {
        match_dimensions<N == 1>::check();
        const SZ indices[] = {_n1};
        return internal_index_nd<1>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2) const {
        match_dimensions<N == 2>::check();
        const SZ indices[] = {_n1, _n2};
        return internal_index_nd<2>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3) const {
        match_dimensions<N == 3>::check();
        const SZ indices[] = {_n1, _n2, _n3};
        return internal_index_nd<3>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3, SZ _n4) const {
        match_dimensions<N == 4>::check();
        const SZ indices[] = {_n1, _n2, _n3, _n4};
        return internal_index_nd<4>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5) const {
        match_dimensions<N == 5>::check();
        const SZ indices[] = {_n1, _n2, _n3, _n4, _n5};
        return internal_index_nd<5>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6) const {
        match_dimensions<N == 6>::check();
        const SZ indices[] = {_n1, _n2, _n3, _n4, _n5, _n6};
        return internal_index_nd<6>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7) const {
        match_dimensions<N == 7>::check();
        const SZ indices[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7};
        return internal_index_nd<7>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8) const {
        match_dimensions<N == 8>::check();
        const SZ indices[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7, _n8};
        return internal_index_nd<8>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8, SZ _n9) const {
        match_dimensions<N == 9>::check();
        const SZ indices[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7, _n8, _n9};
        return internal_index_nd<9>::compute(size_, indices);
    }
    inline SZ index(SZ _n1, SZ _n2, SZ _n3, SZ _n4, SZ _n5, SZ _n6, SZ _n7, SZ _n8, SZ _n9, SZ _n10)
        const {
        match_dimensions<N == 10>::check();
        const SZ indices[] = {_n1, _n2, _n3, _n4, _n5, _n6, _n7, _n8, _n9, _n10};
        return internal_index_nd<10>::compute(size_, indices);
    }

    inline T& at(SZ _i1) {
        match_dimensions<N == 1>::check();
        return data_[_i1];
    }
    inline T& at(SZ _i1, SZ _i2) {
        match_dimensions<N == 2>::check();
        return data_[index(_i1, _i2)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3) {
        match_dimensions<N == 3>::check();
        return data_[index(_i1, _i2, _i3)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4) {
        match_dimensions<N == 4>::check();
        return data_[index(_i1, _i2, _i3, _i4)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5) {
        match_dimensions<N == 5>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6) {
        match_dimensions<N == 6>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7) {
        match_dimensions<N == 7>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7, SZ _i8) {
        match_dimensions<N == 8>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7, _i8)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7, SZ _i8, SZ _i9) {
        match_dimensions<N == 9>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7, _i8, _i9)];
    }
    inline T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7, SZ _i8, SZ _i9, SZ _i10) {
        match_dimensions<N == 10>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7, _i8, _i9, _i10)];
    }

    inline const T& at(SZ _i1) const {
        match_dimensions<N == 1>::check();
        return data_[_i1];
    }
    inline const T& at(SZ _i1, SZ _i2) const {
        match_dimensions<N == 2>::check();
        return data_[index(_i1, _i2)];
    }
    inline const T& at(SZ _i1, SZ _i2, SZ _i3) const {
        match_dimensions<N == 3>::check();
        return data_[index(_i1, _i2, _i3)];
    }
    inline const T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4) const {
        match_dimensions<N == 4>::check();
        return data_[index(_i1, _i2, _i3, _i4)];
    }
    inline const T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5) const {
        match_dimensions<N == 5>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5)];
    }
    inline const T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6) const {
        match_dimensions<N == 6>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6)];
    }
    inline const T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7) const {
        match_dimensions<N == 7>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7)];
    }
    inline const T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7, SZ _i8) const {
        match_dimensions<N == 8>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7, _i8)];
    }
    inline const T& at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7, SZ _i8, SZ _i9)
        const {
        match_dimensions<N == 9>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7, _i8, _i9)];
    }
    inline const T&
    at(SZ _i1, SZ _i2, SZ _i3, SZ _i4, SZ _i5, SZ _i6, SZ _i7, SZ _i8, SZ _i9, SZ _i10) const {
        match_dimensions<N == 10>::check();
        return data_[index(_i1, _i2, _i3, _i4, _i5, _i6, _i7, _i8, _i9, _i10)];
    }

    inline array_iterator<array_base<T, SZ, N> > begin() {
        return array_iterator<array_base<T, SZ, N> >(*this, 0);
    }
    inline array_iterator<array_base<T, SZ, N> > end() {
        return array_iterator<array_base<T, SZ, N> >(*this, this->numel());
    }
    inline const_array_iterator<array_base<T, SZ, N> > begin() const {
        return const_array_iterator<array_base<T, SZ, N> >(*this, 0);
    }
    inline const_array_iterator<array_base<T, SZ, N> > end() const {
        return const_array_iterator<array_base<T, SZ, N> >(*this, this->numel());
    }

  private:
    data_ptr<T, SZ> data_;
    SZ size_[N];

  private:
    inline void ensureCapacity(SZ _newNumel) {
        if (_newNumel > data_.capacity()) {
            SZ i = data_.capacity();
            if (i < 16) {
                i = 16;
            }

            while (i < _newNumel) {
                if (i > 1073741823) {
                    i = MAX_int32_T;
                } else {
                    i <<= 1;
                }
            }
            data_.reserve(i);
        }
        data_.resize(_newNumel);
    }
};

// The standard coder::array class with base type and number of dimensions.
template <typename T, int32_T N>
class array : public array_base<T, SizeType, N> {
  public:
    inline array()
        : array_base<T, SizeType, N>() {
    }
    inline array(const array<T, N>& _other)
        : array_base<T, SizeType, N>(_other) {
    }
    inline array(const array_base<T, SizeType, N>& _other)
        : array_base<T, SizeType, N>(_other) {
    }
    inline array(const T* _data, const SizeType* _sz)
        : array_base<T, SizeType, N>(_data, _sz) {
    }
};

// Specialize on char_T (row vector) for better support on strings.
template <>
class array<char_T, 2> : public array_base<char_T, SizeType, 2> {
  public:
    inline array()
        : array_base() {
    }
    inline array(const array<char_T, 2>& _other)
        : array_base<char_T, SizeType, 2>(_other) {
    }
    inline array(const array_base<char_T, SizeType, 2>& _other)
        : array_base<char_T, SizeType, 2>(_other) {
    }
    inline array(const char_T* _data, const SizeType* _sz)
        : array_base<char_T, SizeType, 2>(_data, _sz) {
    }

    inline array(const std::string& _str) {
        SizeType sz[2] = {1, static_cast<SizeType>(_str.size())};
        array<char_T, 2> arr(static_cast<const char_T*>(_str.c_str()), &sz[0]);
        operator=(arr);
    }

    inline array(const char_T* _str) {
        SizeType sz[2] = {1, static_cast<SizeType>(strlen(_str))};
        array<char_T, 2> arr(_str, &sz[0]);
        operator=(arr);
    }

    inline array(const std::vector<char_T>& _vec) {
        set(const_cast<char_T*>(&_vec[0]), 1, static_cast<SizeType>(_vec.size()));
    }

    inline operator std::string() const {
        return std::string(static_cast<const char*>(&(*this)[0]), static_cast<int>(size(1)));
    }
};

// Specialize on 2 dimensions for better support interactions with
// std::vector and row vectors.
template <typename T>
class array<T, 2> : public array_base<T, SizeType, 2> {
  public:
    inline array()
        : array_base<T, SizeType, 2>() {
    }
    inline array(const array<T, 2>& _other)
        : array_base<T, SizeType, 2>(_other) {
    }
    inline array(const array_base<T, SizeType, 2>& _other)
        : array_base<T, SizeType, 2>(_other) {
    }
    inline array(const T* _data, const SizeType* _sz)
        : array_base<T, SizeType, 2>(_data, _sz) {
    }

    inline array(const std::vector<T>& _vec) {
        array_base<T, SizeType, 2>::set(const_cast<T*>(&_vec[0]), 1,
                                        static_cast<SizeType>(_vec.size()));
    }

    inline operator std::vector<T>() const {
        const T* p = static_cast<const T*>(&(*this)[0]);
        return std::vector<T>(
            p, p + array_base<T, SizeType, 2>::size(0) * array_base<T, SizeType, 2>::size(1));
    }
};

// Specialize on 1 dimension for better support with std::vector and
// column vectors.
template <typename T>
class array<T, 1> : public array_base<T, SizeType, 1> {
  public:
    inline array()
        : array_base<T, SizeType, 1>() {
    }
    inline array(const array<T, 1>& _other)
        : array_base<T, SizeType, 1>(_other) {
    }
    inline array(const array_base<T, SizeType, 1>& _other)
        : array_base<T, SizeType, 1>(_other) {
    }
    inline array(const T* _data, const SizeType* _sz)
        : array_base<T, SizeType, 1>(_data, _sz) {
    }

    inline array(const std::vector<T>& _vec) {
        this->set(const_cast<T*>(&_vec[0]), static_cast<SizeType>(_vec.size()));
    }

    inline operator std::vector<T>() const {
        const T* p = static_cast<const T*>(&(*this)[0]);
        return std::vector<T>(p, p + array_base<T, SizeType, 1>::size(0));
    }
};

} // namespace coder

#endif
