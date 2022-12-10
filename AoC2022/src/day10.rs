use std::fs;

pub fn day10(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.trim();

    let program = data.lines()
        .map(|line| line.split(' ').collect::<Vec<&str>>())
        // .flat_map(|line| vec![Move::new(line[0]); line[1].parse::<usize>().unwrap()].into_iter())
        .collect::<Vec<Vec<&str>>>();
    let mut tick = 0;
    let mut register = 1;
    let mut signal = Vec::new();
    for instr in &program {
        print!("{}", if tick % 40 >= register - 1 && tick % 40 <= register + 1 { '#' } else { '.' });
        match instr[0] {
            "noop" => {
                tick += 1;
                if (tick + 20) % 40 == 0 {
                    signal.push(tick * register);
                };
                if tick % 40 == 0 {
                    println!();
                }
            },
            "addx" => {
                tick += 1;
                if (tick + 20) % 40 == 0 {
                    signal.push(tick * register);
                };
                if tick % 40 == 0 {
                    println!();
                }
                print!("{}", if tick % 40 >= register - 1 && tick % 40 <= register + 1 { '#' } else { '.' });
                tick += 1;
                if (tick + 20) % 40 == 0 {
                    signal.push(tick * register);
                };
                if tick % 40 == 0 {
                    println!();
                }
                register += instr[1].parse::<i32>().unwrap()
            },
            _ => panic!("Unsupported opcode"),
        }
    }
    println!("register {register}");
    println!("signal {signal:?}");
    println!("{}", signal.iter().sum::<i32>());
}