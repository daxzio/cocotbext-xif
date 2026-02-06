set interimfile "../../../interim.txt"
if {[catch {open ${interimfile} "r"} fp error_message]} {
    set version "00000000"
} else {
    set version [gets $fp]
    close $fp
}

set now [clock seconds]
set timestr [clock format $now -format "%y%m%d"]

set BASE_DIR [pwd]
set BITSTREAM_DIR "${BASE_DIR}/../../../../bitstreams"
file mkdir ${BITSTREAM_DIR}

#set NAME [get_property NAME [current_project]]
set x [lrange [file split $BASE_DIR] end-1 end-1]
regsub ".runs" $x "" NAME
puts "project name found: ${NAME}"

set bitstream [glob -directory $BASE_DIR {*.bit}]
# for {set i 0} {$i < 100} {incr i} {
#     set bitfile "${BITSTREAM_DIR}/${NAME}-${timestr}.0${i}.bit"
#     if {![file exists $bitfile]} {
#         break
#     }
# }

set insertion_index 6
set new_character "."
set part1 [string range $version 0 $insertion_index-1]
set part2 [string range $version $insertion_index end]
set version_rev "$part1$new_character$part2"

# set version_rev [string insert $version 6 .]
puts "Using version ${NAME}-${version_rev}"

set bitfile "${BITSTREAM_DIR}/${NAME}-${version_rev}.bit"
file copy -force $bitstream $bitfile

regsub ".bit$" $bitfile ".mcs" mcsfile
# regsub ".bit$" $bitfile ".prm" prmfile
# 
write_cfgmem -format mcs \
    -force \
    -checksum \
    -interface SPIx4 \
    -size 256 \
    -loadbit "up 0x0 ${bitfile}" \
    -file ${mcsfile}
# 
# puts $version
# set versionfile "../../../version.txt"
# set versionfile "version2.txt"
# 

set versionfile "../../../version.txt"
set outfile [open ${versionfile} w]    
puts $outfile "$version"
close $outfile
file delete -force ${interimfile}

# # puts "tclapp"
# # puts "Setting Version to: $::tclapp::daxzio::version::rev"
# create_hw_cfgmem -hw_device [lindex [get_hw_devices xc7k325t_0] 0] [lindex [get_cfgmem_parts {s25fl256sxxxxxx0-spi-x1_x2_x4}] 0]
# set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7k325t_0] 0]]
# set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7k325t_0] 0]]
# set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7k325t_0] 0]]
# set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7k325t_0] 0]]
# set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7k325t_0] 0]]
# refresh_hw_device [lindex [get_hw_devices xc7k325t_0] 0]
# 
# write_cfgmem -format mcs -force -checksum -interface SPIx4 -size 256 \
#     -loadbit {up 0x00000000 /mnt/sda/projects/endurahulk/digital/DIG_TOP/emulation/synth/lugus_base_g2/build/lugus_hulk_g2.runs/impl_1/../../../../bitstreams/lugus_hulk_g2-250328.00.bit \
#               up 0x00800000 /mnt/sda/projects/endurahulk/digital/DIG_TOP/emulation/synth/lugus_base_g2/build/lugus_hulk_g2.runs/impl_1/../../../../bitstreams/lugus_hulk_g2-250327.05.bit} \
#     -file /mnt/sda/projects/endurahulk/digital/DIG_TOP/emulation/synth/lugus_base_g2/build/lugus_hulk_g2.runs/impl_1/../../../../bitstreams/lugus_hulk_g2-250328.mcs
# write_cfgmem -format mcs -force -checksum -interface SPIx4 -size 256 \
#     -loadbit {up 0x00000000 /mnt/sda/projects/endurahulk_v2/digital/DIG_TOP/emulation/synth/bitstreams/lugus_hulk_v1-250429.01.bit \
#               up 0x00800000 /mnt/sda/projects/endurahulk_v2/digital/DIG_TOP/emulation/synth/bitstreams/lugus_hulk_v1-250424.07.bit} \
#     -file /mnt/sda/projects/endurahulk_v2/digital/DIG_TOP/emulation/synth/bitstreams/lugus_hulk_v1-250429.mcs
