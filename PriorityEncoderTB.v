`include "PriorityEncoder.v"


// ----------------Тестбенч для приоритетного шифратора------------------
// Каждая строка файла с тестами должна представлять собой:
// <input_vector>, <expected_position>, <expected_is_onehot>, <expected_parity>
// ----------------------------------------------------------------------
module TB();
    integer file;

// --------------------Tested module instantiation------------------------
    // variables linked to module
    wire [$clog2(`WIDTH) - 1:0]  position;
    reg  [`WIDTH - 1: 0]         vector;
    reg  [`WIDTH - 1: 0]         test_vectors [0:`NUM_OF_TESTS - 1];
    wire is_onehot;
    wire parity;

    encoder #(
        .WIDTH(`WIDTH)
    ) TB_encoder (
        .vector(vector),
        .position(position),
        .is_onehot(is_onehot),
        .parity(parity)
    );
// -----------------------------------------------------------------------

    // Copy of variables linked to module
    reg [$clog2(`WIDTH) - 1:0]  TB_EXP_position;
    reg  [`WIDTH - 1: 0]         TB_vector;
    reg TB_EXP_is_onehot;
    reg TB_EXP_parity;

    // File opening initial
    initial begin: OpenFile
        file = $fopen(`TB_FILE_NAME, "r");
         if (file == 0) begin
            $display("Не смог открыть файл тестбенча.");
            $finish;
        end
    end

// -----------------------------------------Main Testing--------------------------------------------
    reg AllCorrect = 1;
    initial begin: Tests
        integer check;
        for (integer i = 0; i < `NUM_OF_TESTS && !$feof(file); i = i+1) begin
            check = $fscanf(file, "%b, %d, %b, %b\n", TB_vector, TB_EXP_position, 
                                                      TB_EXP_is_onehot, TB_EXP_parity);
            if (check != 4) begin
                $display("%c[1;31m[ОШИБКА]%c[0m: неправильный формат файла тестбенча", `ESC, `ESC);
                $finish;
            end

            vector <= TB_vector;
            #10;

            // if Expected != received
            if ((position !== TB_EXP_position) | (is_onehot !== TB_EXP_is_onehot) | (parity !== TB_EXP_parity)) begin
                $write("%c[1;31m[ОШИБКА]%c[0m в тесте номер %1d\n", `ESC, `ESC, i + 1);
                $write("\tВектор: %b\n", TB_vector);
                $write("\tПолученные/Ожидаемые\n"); 
                if (position    !== TB_EXP_position)
                    $write("\tposition: %d\t%d\n", position,  TB_EXP_position);
                if (is_onehot   !== TB_EXP_is_onehot)
                    $write("\tis_onehot: %d\t %d\n", is_onehot, TB_EXP_is_onehot);
                if (parity      !== TB_EXP_parity)
                    $write("\tparity:    %d\t %d\n", parity,    TB_EXP_parity);

                AllCorrect = 0;
            end
        end

        if (AllCorrect) begin
            $display("%c[1;32mВсе тесты пройдены успешно!%c[0m", `ESC, `ESC);
        end
        $finish;
    end
// -------------------------------------------------------------------------------------------------
endmodule
