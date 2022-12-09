use std::collections::vec_deque::VecDeque;
use std::fs;
use regex::Regex;

fn parse_stacks(data: &str) -> [VecDeque<char>; 9] {
    let chars = data.chars().collect::<Vec<char>>();
    let chunks = chars.chunks(4);
    let mut stack = 0;
    let mut stacks: [VecDeque<char>; 9] = [
        VecDeque::new(), VecDeque::new(), VecDeque::new(),
        VecDeque::new(), VecDeque::new(), VecDeque::new(),
        VecDeque::new(), VecDeque::new(), VecDeque::new(), ];
    for chunk in chunks {
        if chunk[1] == '1' {
            break;
        }
        if chunk[1] != ' ' {
            stacks[stack].push_back(chunk[1]);
        }
        stack = if chunk[3] == '\n' { 0 } else { stack + 1 }
    }
    stacks.clone()
}

fn parse_moves(data: &str) -> Vec<(usize,usize,usize)> {
    let re = Regex::new(r"move (\d+) from (\d+) to (\d+)").unwrap();
    data.split("\n")
        .map(|line| {
            let cap = re.captures_iter(line).next().unwrap();
            (cap[1].parse::<usize>().unwrap(),
             cap[2].parse::<usize>().unwrap()-1,
             cap[3].parse::<usize>().unwrap()-1)
        })
        .collect()
}

pub fn day5(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.split("\n\n").collect::<Vec<&str>>();
    let stacks = parse_stacks(data[0]);
    let moves = parse_moves(data[1].trim());

    let mut stacks1 = stacks.clone();
    for (count, from, to) in &moves {
        for _ in 0..*count {
            let popped = stacks1[*from].pop_front().unwrap();
            stacks1[*to].push_front(popped);
        }
    }
    println!("{}", stacks1.iter()
        .map(|vec| vec.front().unwrap().to_string())
        .reduce(|acc, it| acc + &it)
        .unwrap());

    let mut stacks1 = stacks.clone();
    for (count, from, to) in &moves {
        let mut popped = Vec::new();
        for _ in 0..*count {
            let p = stacks1[*from].pop_front().unwrap();
            popped.push(p);
        }
        for _ in 0..*count {
            stacks1[*to].push_front(popped.pop().unwrap())
        }
    }
    println!("{}", stacks1.iter()
        .map(|vec| vec.front().unwrap().to_string())
        .reduce(|acc, it| acc + &it)
        .unwrap());
}