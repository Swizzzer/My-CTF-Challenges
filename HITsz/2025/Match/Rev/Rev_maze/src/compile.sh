clang -o maze-pre chall.c -no-pie
python3 postprocess.py
rm maze-pre
# strip sig-sigh