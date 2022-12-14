use std::cmp::Ordering;
use std::fs;
use std::str::FromStr;
use Packet::{Int, List};

#[derive(Debug, Clone, Eq, PartialEq)]
enum Packet {
    List(Vec<Packet>),
    Int(i32),
}

impl FromStr for Packet {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if s.starts_with("[") {
            Ok(List(tokenize(&s[1..s.len() - 1]).into_iter()
                .map(|tok| tok.parse::<Self>().unwrap()) // TODO use ?
                .collect::<Vec<Self>>()))
        } else {
            Ok(Int(s.parse::<i32>().unwrap())) // TODO use ?
        }
    }
}

impl PartialOrd for Packet {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Packet {
    fn cmp(&self, other: &Self) -> Ordering {
        match self {
            List(vec) => {
                match other {
                    List(other_vec) => {
                        vec.cmp(other_vec)
                    },
                    int => {
                        let vec1 = vec![int.clone()];
                        vec.cmp(&vec1)
                    },
                }
            },
            int @ Int(val) => {
                match other {
                    List(other_vec) => {
                        let vec1 = vec![int.clone()];
                        vec1.cmp(other_vec)
                    },
                    Int(other_val) => val.cmp(other_val),
                }
            }
        }
    }
}

fn tokenize(s: &str) -> Vec<String> {
    let mut current = String::new();
    let mut tokens = Vec::new();
    let mut bracket_cnt = 0;
    for c in s.chars() {
        if bracket_cnt == 0 {
            if c == ',' {
                tokens.push(current.clone());
                current.clear();
            } else {
                if c == '[' {
                    bracket_cnt += 1;
                }
                current.push(c);
            }
        } else {
            bracket_cnt += match c {
                '[' => 1,
                ']' => -1,
                _ => 0,
            };
            current.push(c);
        }
    }
    if !current.is_empty() {
        tokens.push(current);
    }
    tokens
}

pub fn day13(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.trim();

    let part1 = data.split("\n\n")
        .map(|both| both.split("\n")
            .map(|part| part.parse::<Packet>().unwrap())
            .collect::<Vec<Packet>>())
        .enumerate()
        .filter(|(_, vecs)| vecs[0] < vecs[1])
        .map(|(idx, _)| idx + 1)
        .sum::<usize>();
    println!("{part1}");


    let data = data.to_string() + "\n[[2]]\n[[6]]";
    let mut packets = data.lines()
        .filter(|line| !line.is_empty())
        .map(|line| line.parse::<Packet>().unwrap())
        .collect::<Vec<Packet>>();
    packets.sort();
    let part2 = packets.iter()
        .enumerate()
        .filter(|&(_, v)| v == &List(vec![List(vec![Int(2)])]) || v == &List(vec![List(vec![Int(6)])])) // TODO why &
        .map(|(idx, _)| idx + 1)
        .reduce(|l, r| l * r)
        .unwrap();
    println!("{part2}");
}