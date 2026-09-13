#!/usr/bin/env node
// Guards the two things that decide what plugin users receive, and when.
//
// 1. No `version` in plugin.json or in the marketplace entry. Without one,
//    Claude Code uses the commit SHA of `main` as the version, so every push to
//    `main` reaches users. A version string would pin them to it until bumped.
// 2. plugin.json's `skills` array is exactly the promoted set: every skill
//    under skills/engineering/ and skills/productivity/, nothing else.
//
// Exits 1 with one line per problem; prints a single OK line otherwise.

import { existsSync, readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const repo = join(dirname(fileURLToPath(import.meta.url)), "..");
const readJson = (path) => JSON.parse(readFileSync(join(repo, path), "utf8"));

const plugin = readJson(".claude-plugin/plugin.json");
const marketplace = readJson(".claude-plugin/marketplace.json");
const problems = [];

if ("version" in plugin) {
  problems.push(
    `.claude-plugin/plugin.json sets "version": "${plugin.version}". Remove it: the commit SHA of main is the version.`,
  );
}

const entry = marketplace.plugins?.find((p) => p.name === plugin.name);
if (!entry) {
  problems.push(`.claude-plugin/marketplace.json has no entry named "${plugin.name}".`);
} else {
  if ("version" in entry) {
    problems.push(
      `.claude-plugin/marketplace.json entry "${plugin.name}" sets "version": "${entry.version}". Remove it.`,
    );
  }
  if (entry.source?.ref !== "main") {
    problems.push(
      `.claude-plugin/marketplace.json entry "${plugin.name}" must load from ref "main", not ${JSON.stringify(entry.source?.ref)}.`,
    );
  }
}

const promoted = ["engineering", "productivity"].flatMap((bucket) =>
  readdirSync(join(repo, "skills", bucket), { withFileTypes: true })
    .filter((d) => d.isDirectory() && existsSync(join(repo, "skills", bucket, d.name, "SKILL.md")))
    .map((d) => `./skills/${bucket}/${d.name}`),
);
const listed = plugin.skills ?? [];

for (const path of promoted) {
  if (!listed.includes(path)) problems.push(`${path} is promoted but missing from plugin.json's skills.`);
}
for (const path of listed) {
  if (!promoted.includes(path)) problems.push(`${path} is in plugin.json's skills but is not a promoted skill.`);
}
for (const path of new Set(listed.filter((p, i) => listed.indexOf(p) !== i))) {
  problems.push(`${path} is listed more than once in plugin.json's skills.`);
}

if (problems.length > 0) {
  for (const problem of problems) console.error(problem);
  process.exit(1);
}

console.log(`plugin manifest OK: ${listed.length} promoted skills, versioned by commit SHA.`);
