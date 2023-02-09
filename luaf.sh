find . -name '*.lua' -type f -print0 | while IFS= read -r -d '' file; do
  lua-format "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done

