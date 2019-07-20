del ..\WW6_ACME\*.ASM
for %%1 in (*.ASM) do ..\converttoacme\converttoacme %%1 conversion.json > ..\WW6_ACME\%%1
