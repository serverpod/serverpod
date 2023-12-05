find . -type d -name "protocol" -print0 | while IFS= read -r -d '' dir; do
  find "$dir" -type f -name "*.yaml" ! -name "*.spy.yaml" -print0 | while IFS= read -r -d '' file; do
    baseName=$(basename "$file" .yaml)
    dirName=$(dirname "$file")
    mv "$file" "${dirName}/${baseName}.spy.yaml"
  done
done