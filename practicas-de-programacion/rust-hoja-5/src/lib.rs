extern crate num_traits;
extern crate num;

use std::ops::{Rem, Div, Mul, Add, Sub};
use num_traits::cast::FromPrimitive;
use num::Num;
use std::cmp;

pub fn pot_log(a: u32, n: u32) -> u32 {
    ggpot_log(a, n, 1, 1, a)
}

fn ggpot_log(a : u32, n: u32, u: u32, v: u32, z: u32) -> u32 {
    if n == 0 {
	u
    } else if n % 2 == 0 {
	ggpot_log(a, n / 2, u, 2*v, z*z)
    } else {
	ggpot_log(a, n / 2, u*z, 2*v, z*z)
    }
}

pub fn contar_aprobados<T>(v: &[T]) -> usize
where T: PartialOrd + FromPrimitive {
    gcontar_aprobados(v,0,0)
}

fn gcontar_aprobados<T>(v: &[T], n: usize, i: usize) -> usize
where T: PartialOrd  + FromPrimitive
{
    let five = FromPrimitive::from_i8(5).unwrap();
    if n == v.len() {
	i
    } else {
	gcontar_aprobados(v,
			  n + 1,
			  if v[n] >= five {i + 1} else {i})
    }
}

#[allow(clippy::just_underscores_and_digits)]
pub fn desde_digitos<T>(v: &[T]) -> T
where T: Num + FromPrimitive + Copy
{
    let mut n : usize = 0;
    let mut b = T::one();
    let mut s = T::zero();
    let _10 = FromPrimitive::from_u8(10).unwrap();
    while n != v.len() {
	n += 1;
	b = b * _10;
    }
    while n != 0 {
	n -= 1;
	b = b / _10;
	s = s + v[n] * b;
    }
    s
}

pub fn complementario<T>(n: T) -> T
where T: PartialEq + Num + Copy
{
    match gcomplementario(n, T::one(), T::zero()) {
	Some(num) => num,
	None => panic!("No se pudieron convertir las constantes al tipo solicitado.")
    }
	
}
#[allow(clippy::just_underscores_and_digits)]
fn gcomplementario<T> (n: T, b: T, r: T) -> Option<T>
where T: PartialEq + Num + Copy
{
    let _1 = T::one();
    let _2 = _1 + _1;
    let _10 = _2 + _2 + _2 + _2 +_2;
    let _9 = _10 - _1;
    if n.is_zero() {
	Some(r)
    } else {
	// Los interrogantes hacen que si el valor Option<T> evalua a
	// None en lugar de a Some(T) se pare de calcular y se devuelva
	// None, es decir, que alguna de las conversiones no funciono.
	gcomplementario(n / _10,
			b * _10,
			r + b * _9 - b * (n % _10))
    }
}
// Necesario para que el compilador no se enfade por no usarla.
pub fn gcomplementario_ideomatico<T> (n: T, b: T, r: T) -> T
where T: PartialEq + PartialEq<u32>
    + Mul<Output = T> + Div<Output = T> + Rem<Output = T>
    + Div<u32, Output = T> + Mul<u32, Output = T> + Rem<u32, Output = T>
    + Add<Output = T> + Sub<Output = T>
    + Copy
{
    // Usamos shadowing para reescribir r, b y n como variables mutables,
    // esto funciona por que las variables en Rust estan restringidas al
    // bloque que las contiene.
    let (mut r, mut b, mut n) = (r, b, n);
    // Convertimos la recurrencia en una iteracion.
    loop {
	if n == 0 {
	    return r;
	} else {
	    r = r + b * 9 - b * (n % 10);
	    b = b * 10;
	    n = n / 10;
	}
    }
}

pub fn max_resta(v: &[i32]) -> i32 {
    gmax_resta(v, 0).0
}

fn gmax_resta(v: &[i32], n: usize) -> (i32, i32) {
    if n == v.len() - 2 {
	(v[n] - v[n + 1], v[n + 1])
    } else {
	let (r, s) = gmax_resta(v, n + 1);
	(cmp::max(r, v[n] - s), cmp::min(v[n], s))
    }
}

#[cfg(test)]
mod tests {

    use super::*;
    
    #[test]
    fn pot_zero_as_exponent() {
        assert_eq!(1,pot_log(4, 0));
    }
    #[test]
    fn pot_one_as_exponent() {
	assert_eq!(2, pot_log(2, 1));
    }
    #[test]
    fn pot_even_exponent() {
	assert_eq!(u32::pow(3, 10), pot_log(3, 10));
    }
    #[test]
    fn pot_odd_exponent() {
	assert_eq!(u32::pow(3, 11), pot_log(3, 11));
    }
    #[test]
    fn hay_aprobados() {
	assert_eq!(2, contar_aprobados(&[3,2,5,8,1,0]));
    }
    #[test]
    fn hay_aprobados_float() {
	assert_eq!(2, contar_aprobados(&[3.3 ,2.5 ,5.1 ,8.9 ,1. ,0. ]));
    }
    #[test]
    fn no_hay_aprobados() {
	assert_eq!(0, contar_aprobados(&[0, 1, 0 ,4]));
    }
    #[test]
    fn no_hay_aprobados_float() {
	assert_eq!(0, contar_aprobados(&[0., 1.4, 0. ,4.]));
    }
    #[test]
    fn a_digitos_ejemplo_i32() {
	assert_eq!(741, desde_digitos(&[1,4,7]));
    }
    #[test]
    fn complementario_ejemplo_i32() {
	assert_eq!(853279_i32, complementario(146720_i32));
    }
    #[test]
    fn complementario_ejemplo_u32() {
	assert_eq!(853279_u32, complementario(146720_u32));
    }
    #[test]
    fn complementario_ejemplo_u64() {
	assert_eq!(853279_u64, complementario(146720_u64));
    }

    #[test]
    fn complementario_ideomatico_ejemplo() {
	assert_eq!(853279, gcomplementario_ideomatico(146720,1,0));
    }

    #[test]
    fn max_resta_caso_base() {
	assert_eq!(-1, max_resta(&[2,3]));
    }

    #[test]
    fn max_resta_vector_largo() {
	assert_eq!(2, max_resta(&[2, 0, 1, 3]));
    }
}
