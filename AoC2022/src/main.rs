extern crate core;

use std::collections::HashMap;
use std::env;
use day1::day1;
use day2::day2;
use day3::day3;
use day4::day4;
use day5::day5;
use day6::day6;
use day7::day7;
use day8::day8;
use day9::day9;
use day10::day10;
use day11::day11;

mod day1;
mod day2;
mod day3;
mod day4;
mod day5;
mod day6;
mod day7;
mod day8;
mod day9;
mod day10;
mod day11;

fn _type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>())
}

fn main() {
    let routing: [(u8, fn(&str)); 11] = [
        (1, day1),
        (2, day2),
        (3, day3),
        (4, day4),
        (5, day5),
        (6, day6),
        (7, day7),
        (8, day8),
        (9, day9),
        (10, day10),
        (11, day11),
    ];

    let argv: Vec<String> = env::args().skip(1).collect();
    let (day, input_path) = match argv.len() {
        1 => (argv[0].parse::<u8>().unwrap(), "inputs/day".to_string() + &argv[0] + ".test"),
        2 => (argv[0].parse::<u8>().unwrap(), argv[1].clone()),
        _ => (routing.last().unwrap().0, "inputs/day".to_string() + &routing.last().unwrap().0.to_string() + ".test"),
    };

    let cl: fn(&str) = |_| { println!("Selected day is not implemented"); };
    println!("Executing day {} with file {}", day, input_path);
    HashMap::from(routing).get(&day).unwrap_or(&cl)(&input_path);
}
