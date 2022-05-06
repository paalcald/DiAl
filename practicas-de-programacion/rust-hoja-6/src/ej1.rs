use std::cmp::Ordering;

pub fn busqueda_ternaria<T>(arr: &[T], x: T) -> Option<usize>
where
    T: Ord,
{
    busqueda_ternaria_rec(arr, x, 0, arr.len() - 1)
}

fn busqueda_ternaria_rec<T>(arr: &[T], x: T, c: usize, f: usize) -> Option<usize>
where
    T: Ord,
{
    eprintln!("buscando entre {} y {}", c, f);
    let n: usize = f + 1 - c;
    match n {
        0 | 1 => {
            if arr[c] == x {
                Some(c)
            } else {
                None
            }
        }
        _ => match arr[n / 3].cmp(&x) {
            Ordering::Less => match arr[2 * n / 3].cmp(&x) {
                Ordering::Less => busqueda_ternaria_rec(arr, x, 2 * n / 3 + 1, f),
                Ordering::Equal => Some(2 * n / 3),
                Ordering::Greater => busqueda_ternaria_rec(arr, x, n / 3 + 1, 2 * n / 3 - 1),
            },
            Ordering::Equal => Some(n / 3),
            Ordering::Greater => busqueda_ternaria_rec(arr, x, c, n / 3 - 1),
        },
    }
}

#[cfg(test)]
mod tests {
    use crate::ej1::busqueda_ternaria;

    #[test]
    fn longitud() {
        assert_eq!(5, [1, 2, 3, 4, 5].len());
    }
    #[test]
    fn encuentra() {
        assert_eq!(0, busqueda_ternaria(&[1, 2, 3], 1).unwrap());
    }
    #[test]
    fn encuentra2() {
        assert_eq!(1, busqueda_ternaria(&[1, 2, 3], 2).unwrap());
    }
    #[test]
    fn encuentra3() {
        assert_eq!(2, busqueda_ternaria(&[1, 2, 3], 3).unwrap());
    }
    #[test]
    fn encuentra4() {
        assert_eq!(3, busqueda_ternaria(&[1, 2, 3, 4], 4).unwrap());
    }
    #[test]
    fn encuentra5() {
        assert_eq!(None, busqueda_ternaria(&[1, 2, 3, 4], 5));
    }
}

#[allow(dead_code)]
mod matriz {
    pub fn intercambiar_elemento(arr: &mut [f32], i: usize, j: usize) -> &mut [f32] {
        arr.swap(i, j);
        arr
    }
}
