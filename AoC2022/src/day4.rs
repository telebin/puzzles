use std::fs;

fn parse_line(line: &str) -> ((i32, i32), (i32, i32)) {
    let ranges = line.split(",")
        .map(|r| {
            let nums = r.split("-").map(|s| s.parse::<i32>().unwrap()).collect::<Vec<i32>>();
            (nums[0], nums[1])
        })
        .collect::<Vec<(i32, i32)>>();
    (ranges[0], ranges[1])
}

pub fn day4() {
    let data = fs::read_to_string("inputs/day4.input").expect("the file should be there");
    let data = data.trim();

    println!("{}", data.split("\n")
        .map(|l| parse_line(l))
        .filter(|(l, r)|
            l.0 <= r.0 && l.1 >= r.1 || r.0 <= l.0 && r.1 >= l.1)
        .count());

    println!("{}", data.split("\n")
        .map(|l| parse_line(l))
        .filter(|((ls, le), (rs, re))| // left/right, start/end
            ls <= re && ls >= rs
                || le >= rs && le <= re
                || rs <= le && rs >= ls
                || re >= ls && re <= le)
        .count());
}
