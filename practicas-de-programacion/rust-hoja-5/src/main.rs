fn main() {
    let v : [u32; 6] = [2, 3, 4, 5, 8, 0];
    println!("hay {} aprobados en {:?}", rec_funcs::contar_aprobados(&v), v);
}
