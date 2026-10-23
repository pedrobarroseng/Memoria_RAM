load_package flow
project_new top_memoria -overwrite

set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE EP4CE22F17C6
set_global_assignment -name TOP_LEVEL_ENTITY top_memoria
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

foreach f {ff_D.vhd Registrador_8bits.vhd decodificador_4x16.vhd mux16x8.vhd memoria.vhd debounce.vhd top_memoria.vhd} {
    set_global_assignment -name VHDL_FILE $f
}

# Pinos da DE0-Nano
foreach {nome pino} {
    CLOCK_50    PIN_R8
    {KEY[0]}    PIN_J15
    {KEY[1]}    PIN_E1
    {SW[0]}     PIN_M1
    {SW[1]}     PIN_T8
    {SW[2]}     PIN_B9
    {SW[3]}     PIN_M15
    {LED[0]}    PIN_A15
    {LED[1]}    PIN_A13
    {LED[2]}    PIN_B13
    {LED[3]}    PIN_A11
    {LED[4]}    PIN_D1
    {LED[5]}    PIN_F3
    {LED[6]}    PIN_B1
    {LED[7]}    PIN_L3
    {DADO_N[0]} PIN_N15
    {DADO_N[1]} PIN_P14
    {DADO_N[2]} PIN_L14
    {DADO_N[3]} PIN_N14
    {DADO_N[4]} PIN_M10
    {DADO_N[5]} PIN_L13
    {DADO_N[6]} PIN_J16
    {DADO_N[7]} PIN_K15
    EN_N        PIN_J13
} {
    set_location_assignment $pino -to $nome
}

# Pull-up fraco nas entradas externas: sem fio ligado = nivel alto
foreach nome {{DADO_N[0]} {DADO_N[1]} {DADO_N[2]} {DADO_N[3]} {DADO_N[4]} {DADO_N[5]} {DADO_N[6]} {DADO_N[7]} EN_N} {
    set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to $nome
}

execute_flow -compile
project_close
