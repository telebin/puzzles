use std::fmt::{Display, Formatter, Write};
use std::fs;
use std::ops::RangeInclusive;
use crate::_type_of;

#[derive(Debug, Clone, PartialEq)]
enum Material {
    Air,
    Rock,
    Sand,
}

impl Display for Material {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        f.write_char(match self {
            Material::Air => '.',
            Material::Rock => '#',
            Material::Sand => '+',
        })
    }
}

fn print_map(map: &[Vec<Material>]) {
    for row in map {
        for field in row {
            print!("{field}");
        }
        println!();
    }
}

fn parse_map(source: &str) -> Vec<Vec<Material>> {
    let lines = source.lines()
        .map(|line| line.split(" -> ")
            .map(|coordstr| coordstr.split_once(',').unwrap())
            .map(|(x, y)| (x.parse::<usize>().unwrap(), y.parse::<usize>().unwrap()))
            .collect::<Vec<(usize, usize)>>())
        .collect::<Vec<Vec<(usize, usize)>>>();
    let max = lines.iter().flat_map(|v| v.iter()).map(|(_, y)| y).max().unwrap();
    let mut map = vec![vec![Material::Air; 1000]; max + 2];
    for line in lines {
        for window in line.windows(2) {
            let (oldx, oldy) = window[0];
            let (newx, newy) = window[1];
            for y in find_range(oldy, newy) {
                for x in find_range(oldx, newx) {
                    let row = &mut map.get_mut(y).unwrap(); // TODO wat
                    let pointer = &mut row.get_mut(x).unwrap();
                    **pointer = Material::Rock;
                }
            }
        }
    }
    map
}

fn find_range(l: usize, r: usize) -> RangeInclusive<usize> {
    if r > l {
        l..=r
    } else {
        r..=l
    }
}

fn next_hop(&(x, y): &(usize, usize), map: &Vec<Vec<Material>>) -> Option<(usize, usize)> {
    if y + 1 >= map.len() || map[y + 1][x] == Material::Air {
        Some((x, y + 1))
    } else if map[y + 1][x - 1] == Material::Air {
        Some((x - 1, y + 1))
    } else if map[y + 1][x + 1] == Material::Air {
        Some((x + 1, y + 1))
    } else {
        None
    }
}

fn next_hop2(&(x, y): &(usize, usize), map: &Vec<Vec<Material>>) -> Option<(usize, usize)> {
    if y + 1 >= map.len() {
        None
    } else if map[y + 1][x] == Material::Air {
        Some((x, y + 1))
    } else if map[y + 1][x - 1] == Material::Air {
        Some((x - 1, y + 1))
    } else if map[y + 1][x + 1] == Material::Air {
        Some((x + 1, y + 1))
    } else {
        None
    }
}

fn part_one(map: &mut Vec<Vec<Material>>) -> i32 {
    let mut grains = -1;
    loop {
        grains += 1;
        let mut coords: (usize, usize) = (500, 0);
        while let next = next_hop(&coords, &map) {
            match next {
                Some((x, y)) => {
                    if y >= map.len() {
                        return grains;
                    }
                    coords.0 = x;
                    coords.1 = y;
                }
                None => {
                    let row = &mut map.get_mut(coords.1).unwrap(); // TODO and wat here
                    let pointer = &mut row.get_mut(coords.0).unwrap();
                    **pointer = Material::Sand;
                    break;
                }
            }
        }
    }
}

fn part_two(map: &mut Vec<Vec<Material>>) -> i32 {
    let mut grains = 0;
    while map[0][500] != Material::Sand {
        grains += 1;
        let mut coords: (usize, usize) = (500, 0);
        while let next = next_hop2(&coords, &map) {
            match next {
                Some((x, y)) => {
                    coords.0 = x;
                    coords.1 = y;
                }
                None => {
                    let row = &mut map.get_mut(coords.1).unwrap();
                    let pointer = &mut row.get_mut(coords.0).unwrap();
                    **pointer = Material::Sand;
                    break;
                }
            }
        }
    }
    grains
}


pub fn day14(path: &str) {
    let data = fs::read_to_string(path).expect("the file should be there");
    let data = data.trim();

    let mut map = parse_map(data);
    print_map(&map);
    println!();
    let grains = part_one(&mut map);
    print_map(&map);
    println!("{grains}");
    let mut map = parse_map(data);
    let grains = part_two(&mut map);
    print_map(&map);
    println!("{grains}");
}
