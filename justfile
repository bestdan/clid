[private]
@default:
  just --list

# Show arch and os name
@os-info:
  echo "Arch: {{arch()}}"
  echo "OS: {{os()}}"


# scale jpg image by 50%
[no-cd]
scale-jpg path:
  #!/usr/bin/env python3

  import sys
  import subprocess

  try:
      import PIL.Image
  except ImportError:
      print("Pillow package is not installed. Installing now...")
      subprocess.check_call([sys.executable, "-m", "pip", "install", "pillow"])
      import PIL.Image

  image = PIL.Image.open("{{path}}")
  factor = 0.5
  image = image.resize((round(image.width * factor), round(image.height * factor)))
  image.save("{{path}}.s50.jpg")

# Print something in R
[no-cd]
r-print string:
  #!/usr/bin/env RScript

  print("{{string}}")

[no-cd]
check_unused_files dir:
  #!/usr/bin/env sh
  dcm check-unused-files {{dir}} --monorepo --reporter=json --exclude="{**/*.g.dart,**/*.freezed.dart,**/*_feature.dart,**/*_launcher.dart}" |  jq -r '.unusedFiles[] | select((.usedOnlyInTests != true)) | .path'


[no-cd]
check_unused_code dir:
  #!/usr/bin/env sh
  dcm check-unused-code {{dir}} --monorepo --reporter=json --exclude="{**/*.g.dart,**/*.freezed.dart,**/*_feature.dart,**/*_launcher.dart}" |  jq '.unusedCode[] | .path as $path | .issues[] | {path: $path, declaration: .declarationName}'
