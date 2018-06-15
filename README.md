# Relative To Absolute

Optional setup, you can either choose to use the frontmatter permalink variable or the folder structure it lives in.

1. Path to directory, add `relativetoabsolute.sh` to directory.
2. Make `chmod +x relativetoabsolute.sh` executable.
3. Run `./relativetoabsolute.sh` from directory.
4. If it doesn't recursively check your folders, update `**/*.html` to `**/**/*.html` and so on...


Note: This should be ran right after the wget export of a site.