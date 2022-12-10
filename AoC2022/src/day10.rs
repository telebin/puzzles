use std::fs;

#[derive(Debug)]
enum Op {
    Noop,
    Addx(i32),
}

impl Op {
    fn new(line: &str) -> Vec<Op> {
        let mut instr = line.split(' ');
        match instr.next().unwrap() {
            "noop" => vec![Op::Noop],
            "addx" => vec![Op::Noop, Op::Addx(instr.next().and_then(|i| i.parse::<i32>().ok()).unwrap())],
            op => panic!("Opcode {} not implemented", op),
        }
    }
}

pub fn day10(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.trim();

    let program = data.lines()
        .flat_map(Op::new)
        .collect::<Vec<Op>>();
    let mut tick = 0;
    let mut register = 1;
    let mut signal = Vec::new();
    for instr in &program {
        print!("{}", if tick % 40 >= register - 1 && tick % 40 <= register + 1 { '#' } else { '.' });
        tick += 1;
        if (tick + 20) % 40 == 0 {
            signal.push(tick * register);
        };
        if tick % 40 == 0 {
            println!();
        }
        match instr {
            Op::Addx(value) => register += value,
            _ => (),
        }
    }
    println!("part one: {}", signal.iter().sum::<i32>());
}