use std::collections::HashSet;
use std::fs;

#[derive(Debug, Copy, Clone)]
enum Move {
    R,
    L,
    D,
    U,
}

impl Move {
    fn new(dir: &str) -> Move {
        match dir {
            "R" => Move::R,
            "L" => Move::L,
            "D" => Move::D,
            "U" => Move::U,
            _ => panic!("Wrong direction"),
        }
    }
}

fn needs_move(head: &(i32, i32), tail: &(i32, i32)) -> bool {
    (head.0 - tail.0).abs() > 1 || (head.1 - tail.1).abs() > 1
}

fn move_vec(head: &(i32, i32), tail: &(i32, i32)) -> (i32, i32) {
    let x_move = if head.0 > tail.0 { 1 } else if head.0 < tail.0 { -1 } else { 0 };
    let y_move = if head.1 > tail.1 { 1 } else if head.1 < tail.1 { -1 } else { 0 };
    dbg!((x_move, y_move))
}

pub fn day9(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.trim();

    let moves = data.lines()
        .map(|line| line.split(' ').collect::<Vec<&str>>())
        .flat_map(|line| vec![Move::new(line[0]); line[1].parse::<usize>().unwrap()].into_iter())
        .collect::<Vec<Move>>();

    part_one(&moves);
    part_two(&moves);
}

fn part_one(moves: &Vec<Move>) {
    let mut head_pos = (0, 0);
    let mut tail_pos = (0, 0);
    let mut tail_trace = HashSet::new();
    for mv in moves {
        match mv {
            Move::R => head_pos.0 += 1,
            Move::L => head_pos.0 -= 1,
            Move::U => head_pos.1 += 1,
            Move::D => head_pos.1 -= 1,
        }
        if needs_move(&head_pos, &tail_pos) {
            let (x, y) = move_vec(&head_pos, &tail_pos);
            tail_pos.0 += x;
            tail_pos.1 += y;
            tail_trace.insert(tail_pos.clone());
        }
    }
    println!("{:?}", head_pos);
    println!("{:?}", tail_trace);
    println!("trace len {}", tail_trace.len());
}

fn part_two(moves: &Vec<Move>) {
    let mut tail = vec![(0, 0); 10];
    let mut tail_trace: HashSet<(i32, i32)> = HashSet::new();
    for mv in moves {
        match mv {
            Move::R => tail.get_mut(0).unwrap().0 += 1,
            Move::L => tail.get_mut(0).unwrap().0 -= 1,
            Move::U => tail.get_mut(0).unwrap().1 += 1,
            Move::D => tail.get_mut(0).unwrap().1 -= 1,
        }
        for i in 0..tail.len() - 1 {
            if needs_move(&tail[i], &tail[i + 1]) {
                let (x, y) = move_vec(&tail[i], &tail[i + 1]);
                let mut x1 = tail.get_mut(i + 1).unwrap();
                x1.0 += x;
                x1.1 += y;
            }
        }
        tail_trace.insert(tail.last().unwrap().clone());
    }
    println!("{:?}", tail_trace);
    println!("trace len {}", tail_trace.len());
}

