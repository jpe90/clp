find . -name '*.c' -type f -print0 | while IFS= read -r -d '' file; do
  clang-format "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done
