use std::fs;

pub fn day1() {
    let dbl_sep = "\n\n";
    let sep = "\n";
    let data = fs::read_to_string("inputs/day1.input").expect("the file should be there");
    let data = data.trim();

    let max_calories = data.split(dbl_sep)
        .map(|elf| {
            elf.split(sep)
                .map(|c| c.parse::<u32>().unwrap())
                .sum::<u32>()
        })
        .max();
    println!("{:?}", max_calories.unwrap());

    let mut max_calories = data.split(dbl_sep)
        .map(|elf| {
            elf.split(sep)
                .map(|c| c.parse::<i32>().unwrap())
                .sum::<i32>()
        })
        .collect::<Vec<i32>>();
    max_calories.sort_by_key(|u| -u);
    println!("{:?}", max_calories.get(0..3).unwrap().iter().sum::<i32>());
}