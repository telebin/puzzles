use std::fs;

#[derive(Debug)]
struct Backpack {
    original: String,
    comp1: String,
    comp2: String,
}

impl Backpack {
    fn new(contents: &str) -> Backpack {
        let halflen = contents.len() / 2;
        Backpack {
            original: contents.to_string(),
            comp1: contents[..halflen].to_string(),
            comp2: contents[halflen..].to_string()
        }
    }

    fn find_common(&self) -> char {
        for c in self.comp1.chars() {
            if self.comp2.contains(c) {
                return c;
            }
        }
        panic!("There should be one common character")
    }

    fn common_in_three(&self, snd: &Backpack, trd: &Backpack) -> char {
        for c in self.original.chars() {
            if snd.original.contains(c) {
                if trd.original.contains(c) {
                    return c;
                }
            }
        }
        panic!("There should be one common character")
    }
}

fn prio(c: char) -> u32 {
    let to_subtract = if c.is_lowercase() { 0x60 } else { 65-27 };
    c as u32 - to_subtract
}

pub fn day3() {
    let data = fs::read_to_string("inputs/day3.input").expect("the file should be there");
    let data = data.trim();

    println!("{}", data.split("\n")
        .map(|line| Backpack::new(line))
        .map(|b| prio(b.find_common()))
        .reduce(|acc, p| acc + p)
        .unwrap());
    let mut x = data.split("\n")
        .map(|line| Backpack::new(line));
    let mut sum = 0;
    while let fst = x.next() {
        if fst.is_none() {
            break;
        }
        let fst = fst.unwrap();
        let snd = x.next().unwrap();
        let trd = x.next().unwrap();
        sum += prio(dbg!(fst.common_in_three(&snd, &trd)));
    }
    println!("{}", sum);
}