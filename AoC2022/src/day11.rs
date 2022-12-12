use std::collections::vec_deque::VecDeque;
use std::fs;
use std::ops::{Add, Mul};

#[derive(Debug)]
struct Monkey {
    items: VecDeque<i64>,
    // TODO use FnOnce and closure?
    op: fn(i64, i64) -> i64,
    op_value: Option<i64>,
    test_val: i64,
    on_true: usize,
    on_false: usize,
    inspections: i64,
}

impl Monkey {
    fn new(descr: &str) -> Monkey { // TODO use parse instead?
        let mut lines = descr.lines().skip(1);
        let items = lines.next().unwrap()
            .split_at(18).1
            .split(", ")
            .map(|i| i.parse::<i64>().unwrap())
            .collect::<VecDeque<i64>>();
        let (op, op_value) = parse_op(lines.next().unwrap().split_at(23).1);
        let test_val = lines.next().unwrap()
            .split_at(21).1
            .parse::<i64>()
            .unwrap();
        let on_true = lines.next().unwrap()
            .split_at(29).1
            .parse::<usize>()
            .unwrap();
        let on_false = lines.next().unwrap()
            .split_at(30).1
            .parse::<usize>()
            .unwrap();
        Monkey { items, op, op_value, test_val, on_true, on_false, inspections: 0 }
    }

    fn operate(&self, worry_lv: i64) -> i64 {
        let op = self.op;
        self.op_value.map_or_else(|| op(worry_lv, worry_lv), |v| op(worry_lv, v))
    }
}

fn parse_op(text: &str) -> (fn(i64, i64) -> i64, Option<i64>) {
    let op = match text.chars().next().unwrap() {
        '*' => i64::mul,
        '+' => i64::add,
        _ => panic!("Invalid operation"),
    };
    let v = match &text[2..] {
        "old" => None,
        val => val.parse::<i64>().ok(),
    };
    (op, v)
}

pub fn day11(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.trim();

    do_work(data, 20, part_one);
    do_work(data, 10_000, part_two);
}

fn do_work(data: &str, rounds: i32, task: fn(&Monkey, i64, i64) -> i64) {
    let mut monkeys = data.split("\n\n")
        .map(Monkey::new)
        .collect::<Vec<Monkey>>();
    let modulator = monkeys.iter().map(|m| m.test_val).reduce(|a, i| a * i).unwrap();
    for _ in 0..rounds {
        for midx in 0..monkeys.len() {
            let monkey: &mut Monkey = &mut monkeys[midx];
            let mut throws = Vec::new();
            while let Some(worry_lv) = monkey.items.pop_front() {
                monkey.inspections += 1;
                let worry_lv = task(monkey, worry_lv, modulator);
                let recipient =
                    if worry_lv % monkey.test_val == 0 { monkey.on_true } else { monkey.on_false };
                throws.push((worry_lv, recipient));
            }
            for (what, who) in throws {
                let x = monkeys.get_mut(who).unwrap();
                x.items.push_back(what);
            }
        }
    }
    monkeys.sort_by_key(|m| -m.inspections);
    println!("{:?}", monkeys[..2].iter().map(|m| m.inspections).reduce(|l, r| l * r).unwrap());
}

fn part_one(monkey: &Monkey, worry_lv: i64, _: i64) -> i64 {
    let worry_lv = monkey.operate(worry_lv);
    (worry_lv as f64 / 3.0) as i64
}

fn part_two(monkey: &Monkey, worry_lv: i64, modulator: i64) -> i64 {
    monkey.operate(worry_lv) % modulator
}
