package com.nokia.cs.bdne.codeine.regression.common;

import java.util.ArrayList;
import java.util.List;

public class Adv19_b {

	public static void main(String[] args) {
		int elfCount = 3017957;
		List<Integer> elves = new ArrayList<>(elfCount);
		for (int i = 0; i < elfCount; i++) {
			elves.add(i + 1);
		}
		int index = 0;
		while (elfCount > 1) {
			int toRemove = (index + elfCount / 2) % elfCount;
			int stealingElf = elves.get(index);
			elves.remove(toRemove);
			elfCount = elves.size();
			index = (elves.indexOf(stealingElf) + 1) % elfCount;
			if (elfCount % 1000 == 0) System.out.println(elfCount + " elves still in game");
		}
		System.out.println("result: " + elves.get(0));
	}
}
