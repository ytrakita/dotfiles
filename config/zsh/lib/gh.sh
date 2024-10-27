gcre() {
  git init && git add . && git status && git commit -m "initial commit"
  echo "Repository name: " && read name;
  echo "Repository description: " && read description;
  gh repo create ${name} --description ${description}
  git remote add origin https://github.com/ytrakita/${name}.git
  git branch -M main;
  git push -u origin main;
}
