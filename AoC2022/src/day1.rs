use std::fs;

pub fn day1(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.trim();

    let mut calories: Vec<u32> = data.split("\n\n")
        .map(|elf| {
            elf.split("\n")
                .map(|c| c.parse::<u32>().unwrap())
                .sum::<u32>()
        })
        .collect();
    calories.sort();

    println!("part one: {:?}", calories[calories.len() - 1]);
    println!("part two: {:?}", &calories[calories.len() - 3..].iter().sum::<u32>());
}
