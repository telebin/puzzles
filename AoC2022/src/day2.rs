use std::fs;

enum Move {
    Rock,
    Paper,
    Scissors,
}

impl Move {
    fn value(&self) -> u32 {
        match self {
            Move::Rock => 1,
            Move::Paper => 2,
            Move::Scissors => 3,
        }
    }

    fn points(&self, opponent: &Move) -> u32 {
        match self {
            Move::Rock => match opponent {
                Move::Rock => 3,
                Move::Paper => 0,
                Move::Scissors => 6,
            }
            Move::Paper => match opponent {
                Move::Rock => 6,
                Move::Paper => 3,
                Move::Scissors => 0,
            }
            Move::Scissors => match opponent {
                Move::Rock => 0,
                Move::Paper => 6,
                Move::Scissors => 3,
            }
        }
    }

    fn beats(&self) -> Move {
        match self {
            Move::Rock => Move::Scissors,
            Move::Paper => Move::Rock,
            Move::Scissors => Move::Paper,
        }
    }

    fn succumbs(&self) -> Move {
        match self {
            Move::Rock => Move::Paper,
            Move::Paper => Move::Scissors,
            Move::Scissors => Move::Rock,
        }
    }
}

enum Mode {
    Lose,
    Draw,
    Win,
}

impl Mode {
    fn value(&self) -> u32 {
        match self {
            Mode::Lose => 0,
            Mode::Draw => 3,
            Mode::Win => 6,
        }
    }
}

struct Round {
    opponent: Move,
    me: Move,
}

struct Round2 {
    opponent: Move,
    mode: Mode,
}

impl Round {
    fn new(line: &str) -> Round {
        let pair: Vec<char> = line.split(" ").map(|c| c.chars().next().unwrap()).collect();
        if pair.len() != 2 {
            panic!("Invalid input");
        }
        let opponent = match pair[0] {
            'A' => Move::Rock,
            'B' => Move::Paper,
            'C' => Move::Scissors,
            _ => panic!("Wrong L value")
        };
        let me = match pair[1] {
            'X' => Move::Rock,
            'Y' => Move::Paper,
            'Z' => Move::Scissors,
            _ => panic!("Wrong R value")
        };

        Round { opponent, me }
    }

    fn points(&self) -> u32 {
        self.me.value() + self.me.points(&self.opponent)
    }
}

impl Round2 {
    fn new(line: &str) -> Round2 {
        let pair: Vec<char> = line.split(" ").map(|c| c.chars().next().unwrap()).collect();
        if pair.len() != 2 {
            panic!("Invalid input");
        }
        let opponent = match pair[0] {
            'A' => Move::Rock,
            'B' => Move::Paper,
            'C' => Move::Scissors,
            _ => panic!("Wrong L value")
        };
        let mode = match pair[1] {
            'X' => Mode::Lose,
            'Y' => Mode::Draw,
            'Z' => Mode::Win,
            _ => panic!("Wrong R value")
        };

        Round2 { opponent, mode }
    }

    fn points(&self) -> u32 {
        self.mode.value() + match self.mode {
            Mode::Draw => self.opponent.value(),
            Mode::Win => self.opponent.succumbs().value(),
            Mode::Lose => self.opponent.beats().value(),
        }
    }
}

pub fn day2() {
    let sep = "\n";
    let data = fs::read_to_string("inputs/day2.input").expect("The file should be there");
    let data = data.trim();

    println!("{}", data.split(sep)
        .map(|l| Round::new(l).points())
        .reduce(|acc, item| acc + item)
        .unwrap());
    println!("{}", data.split(sep)
        .map(|l| Round2::new(l).points())
        .reduce(|acc, item| acc + item)
        .unwrap());
}