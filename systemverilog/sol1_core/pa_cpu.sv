package pa_cpu;
  parameter PAGETABLE_RAM_SIZE = 2 ** 13;

  parameter byte unsigned bitpos_cpu_status_dma_ack = 0;
  parameter byte unsigned bitpos_cpu_status_irq_en = 1;
  parameter byte unsigned bitpos_cpu_status_mode = 2;
  parameter byte unsigned bitpos_cpu_status_paging_en = 3;
  parameter byte unsigned bitpos_cpu_status_halt = 4;
  parameter byte unsigned bitpos_cpu_status_displayreg_load = 5;
  // pos 6 undefined for now
  parameter byte unsigned bitpos_cpu_status_dir = 7;

  parameter byte unsigned bitpos_cpu_flags_zf = 0;
  parameter byte unsigned bitpos_cpu_flags_cf = 1;
  parameter byte unsigned bitpos_cpu_flags_sf = 2;
  parameter byte unsigned bitpos_cpu_flags_of = 3;

endpackage
