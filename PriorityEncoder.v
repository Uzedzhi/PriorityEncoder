// ==============Приоритетный шифратор============================
// PARAMETERS:  WIDTH       - ширина входного вектора
// IN:          vector      - данные длины WIDTH
// OUT:         position    - позиция старщей единицы
//              is_onehot   - признак того, что в vector 1 единица
//              parity      - признак нечетного кол-ва 1 в vector
// ===============================================================
module encoder #(
    parameter WIDTH = 32,
    parameter POS_W = $clog2(WIDTH)
)(
    input  [WIDTH-1:0] vector,
    output [POS_W-1:0] position,
    output is_onehot,
    output parity

);
    // Изолирование самого старшего бита в векторе
    // Пример для WIDTH = 8, Vec = 00101001
    // IsolatedTopBit = 00100000
    wire [WIDTH-1:0] IsolatedTopBit;
    generate
        assign IsolatedTopBit[WIDTH - 1] = vector[WIDTH - 1];

        for (genvar i = 0; i < WIDTH - 1; i = i+1) begin: IsolationLoop
            assign IsolatedTopBit[i] = vector[i] & ~(|(vector[WIDTH - 1: i + 1]));
        end        
    endgenerate

    // xor - операция контроля чётности
    assign parity = ^vector;

    // у вектора одна единица, если она уже изолирована
    assign is_onehot = (IsolatedTopBit == vector);

    // получение позиции активного бита в векторе
    // генерация маски i бита побитовой декомпозиции всех чисел от 0 до WIDTH
    // и использование логического ИЛИ с И для получения позиции
    // Пример для WIDTH = 8, Vec = 00001000:
    //      |(00001000 & 11110000) = 0
    //      |(00001000 & 11001100) = 1
    //      |(00001000 & 10101010) = 1
    // position = 3'b11 = 3
    generate
        for (genvar i = 0; i < POS_W; i = i + 1) begin: PositionGenLoop
            wire [WIDTH - 1:0] mask;

            // Делаем маску используя битовое разложение до WIDTH
            for (genvar temp = 0; temp < WIDTH; temp = temp + 1) begin: MaskLoop
                assign mask[temp] = temp[i];
            end

            assign position[i] = |(IsolatedTopBit & mask);
        end
    endgenerate
endmodule