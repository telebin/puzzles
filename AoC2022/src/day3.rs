use std::fs;

type Backpack = str;

fn find_common(backpack: &Backpack) -> char {
    let (l, r) = backpack.split_at(backpack.len() / 2);
    l.chars()
        .find(|&c| r.contains(c))
        .expect("There should be one common character")
}

fn common_in_three(fst: &Backpack, snd: &Backpack, trd: &Backpack) -> char {
    fst.chars()
        .find(|&c| snd.contains(c) && trd.contains(c))
        .expect("There should be one common character")
}

fn prio(c: char) -> u32 {
    let to_subtract = if c.is_lowercase() { 0x60 } else { 0x40 - 26 };
    c as u32 - to_subtract
}

pub fn day3() {
    let data = fs::read_to_string("inputs/day3.input").expect("the file should be there");
    let data = data.trim();

    println!("{}", data.split("\n")
        .map(|b| prio(find_common(b)))
        .sum::<u32>());

    println!("{}", data.split("\n")
        .collect::<Vec<&Backpack>>()
        .chunks(3)
        .map(|chunk| common_in_three(&chunk[0], &chunk[1], &chunk[2]))
        .map(|common| prio(common))
        .sum::<u32>());
}