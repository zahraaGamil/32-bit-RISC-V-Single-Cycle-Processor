
quit -sim

vlib work

vlog *.v

vsim work.tb_top_processor

add wave -position insertpoint sim:/tb_top_processor/*

run -all

wave zoom full