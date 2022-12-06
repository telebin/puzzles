use std::fs;
use std::str::Chars;

pub fn day6() {
    let data = fs::read_to_string("inputs/day6.input").expect("the file should be there");
    let data = data.trim();

    let mut b = [' '; 4];
    let mut chars = data.chars();
    fill(&mut b, &mut chars);
    let mut index = 4;
    while is_distinct(&mut b.clone()) {
        b[index % b.len()] = chars.next().unwrap();
        index += 1;
    }
    println!("part 1: {}", index);

    let mut b = [' '; 14];
    let mut chars = data.chars();
    fill(&mut b, &mut chars);
    let mut index = 14;
    while !is_distinct(&mut b.clone()) {
        b[index % b.len()] = chars.next().unwrap();
        index += 1;
    }
    println!("part 2: {}", index);
}

fn fill(b: &mut [char], chars: &mut Chars) {
    for i in 0..b.len() {
        b[i] = chars.next().unwrap();
    }
}

fn is_distinct(arr: &mut [char]) -> bool {
    arr.sort();
    for i in 0..arr.len() - 1 {
        if arr[i] == arr[i+1] {
            return false
        }
    }
    true
}