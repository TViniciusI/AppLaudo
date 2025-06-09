import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const LaudoApp());
}

class LaudoApp extends StatelessWidget {
  const LaudoApp({super.key});

  // MaterialColor ACCI (azul personalizado)
  static const MaterialColor acciBlue = MaterialColor(
    0xFF0D47A1,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laudo Técnico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: acciBlue,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0D47A1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0D47A1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0D47A1), width: 2),
          ),
          labelStyle: TextStyle(color: Color(0xFF0D47A1)),
          hintStyle: TextStyle(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: const LaudoForm(),
    );
  }
}

class LaudoForm extends StatefulWidget {
  const LaudoForm({super.key});

  @override
  State<LaudoForm> createState() => _LaudoFormState();
}

class _LaudoFormState extends State<LaudoForm> {
  final _picker = ImagePicker();
  final Map<String, TextEditingController> controlle = {
    'os': TextEditingController(),
    'dt_laudo': TextEditingController(),
    'nome': TextEditingController(),
    'para': TextEditingController(),
    'sn': TextEditingController(),
    'fabricante': TextEditingController(),
    'modelo': TextEditingController(),
    'tag': TextEditingController(),
    'diametro': TextEditingController(),
    'flange': TextEditingController(),
    'eletrodo': TextEditingController(),
    'revestimento': TextEditingController(),
    'isol_eletrodo1': TextEditingController(),
    'isol_eletrodo2': TextEditingController(),
    'cont_eletrodo1': TextEditingController(),
    'cont_eletrodo2': TextEditingController(),
    'res_bobina': TextEditingController(),
    'isol_bobina': TextEditingController(),
    'problema': TextEditingController(),
    'motivo': TextEditingController(),
    'causa': TextEditingController(),
    'acao': TextEditingController(),
    'conclusao': TextEditingController(),
    'nm_nome': TextEditingController(),
  };

  final List<String> opcoesDiametro = [
    "Nenhum",
    "1\"",
    "2''",
    "1/2\"",
    "3\"",
    "1  1/2''",
    "6''",
    "0,10''",
    "4''",
    "0,06\"",
    "8''",
    "6mm",
    "4mm",
    "1/8\"",
    "025''",
    "14\"",
    "10\"",
    "1/4\"",
    "12''",
    "0,1\"",
    "2  1/2''",
    "25/1''",
    "8mm",
    "5/32''",
    "5/16''",
    "3/4''",
    "1/16''",
    "3/8\"",
    "36\"",
    "0",
    "1/10''",
    "0.2\"",
    "0.4\"",
    "2,5mm",
    "0,10mm",
    "16\"",
    "1mm",
    "1/6''",
    "0,3\"",
    "N/C",
    "5mm",
    "5''",
    "0,15\"",
    "24''",
    "500mm",
    "4 1/2\"",
    "5 1/6'",
    "2mm",
    "0,12\"",
    "1/12''",
    "20''",
    "38mm",
    "1000mm",
    "350mm",
    "2a12''",
    "18''",
    "FT-048",
    "400MM",
    "1 1/4'",
    "30''",
    "600mm",
    "1500mm",
    "1,2mm",
    "0,3mm",
    "0,15mm",
    "1/24''",
    "1,25\"",
    "1/2 a 28",
    "3  1/2''",
    "3 mm",
    "60MM",
    "DN 01",
    "DN 04",
    "28''",
    "200 mm",
    "100 mm",
    "250 mm",
    "65MM",
    "32''",
    "1/2\"a4\"",
    "2' a 28'",
    "9''",
    "10 MM",
    "22\"",
    "15mm",
    "34''",
    "0.5''",
    "0,30mm",
    "40''",
  ];
  String diametroSelecionado = "Nenhum";

  final List<String> opcoesConexao = [
    "Nenhum",
    "FLANGEADA 150",
    "FLANGEADA 300",
    "FLANGEADA 600",
    "WAFER",
    "TRI CLAMP",
    "SMS ( Macho )",
    "IDF ( Macho )",
    "DIN ( Macho )",
    "RST (Macho )",
    "SMS (Femea )",
    "IDF ( Femea )",
    "DIN ( Femea )",
    "RST (Femea )",
    "Rosca",
    "FLANGEADA 900",
    "FLANGEADA 2500",
  ];
  String conexaoSelecionada = "Nenhum";

  final List<String> opcoesEletrodo = [
    "Nenhum",
    "HASTELLOY",
    "INOX (316L)",
    "PLATINA",
    "TITANIO",
    "ZIRCONIO",
    "NICKEL ALLOY",
    "TÂNTALO",
    "TUNGSTÊNIO",
    "OUTROS",
  ];
  String eletrodoSelecionado = "Nenhum";

  final List<String> opcoesRevestimento = [
    "Nenhum",
    "Tellon",
    "PTFE",
    "PFA",
    "Cerâmica",
    "Poluretano",
    "ETFE",
    "Neoprene",
    "Linater",
    "Ebonite",
  ];
  String revestimentoSelecionado = "Nenhum";

  final List<File?> imagensSelecionadas = [];

  @override
  void initState() {
    super.initState();
    controlle['diametro']!.text = diametroSelecionado;
    controlle['flange']!.text = conexaoSelecionada;
    controlle['eletrodo']!.text = eletrodoSelecionado;
    controlle['revestimento']!.text = revestimentoSelecionado;
  }

  @override
  void dispose() {
    for (var c in controlle.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxHeight = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Laudo'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo no topo
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/logo.png',
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    print('⚠️ Não foi possível carregar assets/logo.png: $error');
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção: Dados Gerais
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dados Gerais',
                      style: TextStyle(
                        color: const Color(0xFF0D47A1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    sizedBoxHeight,
                    // Campo Ordem de Serviço
                    TextField(
                      controller: controlle['os'],
                      decoration: const InputDecoration(
                        labelText: 'Ordem de Serviço',
                        hintText: 'Ex: XXXXX-1',
                        prefixIcon: Icon(Icons.format_list_numbered, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['dt_laudo'],
                      decoration: const InputDecoration(
                        labelText: 'Data do Laudo',
                        hintText: 'DD/MM/AAAA',
                        prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['nome'],
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['para'],
                      decoration: const InputDecoration(
                        labelText: 'Para',
                        prefixIcon: Icon(Icons.business, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botões: Tirar Foto e Desfazer Última
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Tirar Foto'),
                                onPressed: () async {
                                  final imagem = await _picker.pickImage(source: ImageSource.camera);
                                  if (imagem != null) {
                                    setState(() {
                                      imagensSelecionadas.add(File(imagem.path));
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.undo),
                                label: const Text('Remover Última Foto'),
                                onPressed: imagensSelecionadas.isEmpty
                                    ? null
                                    : () {
                                  setState(() {
                                    imagensSelecionadas.removeLast();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: imagensSelecionadas.map((f) {
                            if (f == null) return Container();
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(f, width: 80, height: 80, fit: BoxFit.cover),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção: Identificação do Equipamento
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Identificação do Equipamento',
                      style: TextStyle(
                        color: const Color(0xFF0D47A1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    sizedBoxHeight,
                    TextField(
                      controller: controlle['sn'],
                      decoration: const InputDecoration(
                        labelText: 'S/N',
                        prefixIcon: Icon(Icons.confirmation_num, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['fabricante'],
                      decoration: const InputDecoration(
                        labelText: 'Fabricante',
                        prefixIcon: Icon(Icons.factory, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['modelo'],
                      decoration: const InputDecoration(
                        labelText: 'Modelo',
                        prefixIcon: Icon(Icons.build, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['tag'],
                      decoration: const InputDecoration(
                        labelText: 'TAG',
                        prefixIcon: Icon(Icons.tag, color: Color(0xFF0D47A1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção: Parâmetros Técnicos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Parâmetros Técnicos',
                      style: TextStyle(
                        color: const Color(0xFF0D47A1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    sizedBoxHeight,
                    DropdownButtonFormField<String>(
                      value: diametroSelecionado,
                      items: opcoesDiametro
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            diametroSelecionado = v;
                            controlle['diametro']!.text = v;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Diâmetro',
                        prefixIcon: Icon(Icons.straighten, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: conexaoSelecionada,
                      items: opcoesConexao
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            conexaoSelecionada = v;
                            controlle['flange']!.text = v;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Conexão / Flange',
                        prefixIcon: Icon(Icons.supervisor_account, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: eletrodoSelecionado,
                      items: opcoesEletrodo
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            eletrodoSelecionado = v;
                            controlle['eletrodo']!.text = v;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Eletrodo',
                        prefixIcon: Icon(Icons.flash_on, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: revestimentoSelecionado,
                      items: opcoesRevestimento
                          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setState(() {
                            revestimentoSelecionado = v;
                            controlle['revestimento']!.text = v;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Revestimento',
                        prefixIcon: Icon(Icons.layers, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controlle['isol_eletrodo1'],
                      decoration: const InputDecoration(
                        labelText: 'Isolação Eletrodo 1 (Mohm)',
                        prefixIcon: Icon(Icons.power_off, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['isol_eletrodo2'],
                      decoration: const InputDecoration(
                        labelText: 'Isolação Eletrodo 2 (Mohm)',
                        prefixIcon: Icon(Icons.power_off, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['cont_eletrodo1'],
                      decoration: const InputDecoration(
                        labelText: 'Continuidade Eletrodo 1 (Ohm)',
                        prefixIcon: Icon(Icons.timeline, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['cont_eletrodo2'],
                      decoration: const InputDecoration(
                        labelText: 'Continuidade Eletrodo 2 (Ohm)',
                        prefixIcon: Icon(Icons.timeline, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['res_bobina'],
                      decoration: const InputDecoration(
                        labelText: 'Resistência da Bobina (Ohm)',
                        prefixIcon: Icon(Icons.electrical_services, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['isol_bobina'],
                      decoration: const InputDecoration(
                        labelText: 'Isolação da Bobina (Mohm)',
                        prefixIcon: Icon(Icons.electrical_services, color: Color(0xFF0D47A1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção: Descrição Detalhada
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Descrição Detalhada',
                      style: TextStyle(
                        color: const Color(0xFF0D47A1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    sizedBoxHeight,
                    TextField(
                      controller: controlle['problema'],
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Problema Encontrado',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.report_problem, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['motivo'],
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Motivo',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.info, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['causa'],
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Causa Provável',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.search, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['acao'],
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Ação Corretiva',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.build_circle, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['conclusao'],
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Conclusão',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.check_circle, color: Color(0xFF0D47A1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Seção: Responsável e Botão Gerar PDF
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Finalização',
                      style: TextStyle(
                        color: const Color(0xFF0D47A1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controlle['nm_nome'],
                      decoration: const InputDecoration(
                        labelText: 'Responsável',
                        prefixIcon: Icon(Icons.person_outline, color: Color(0xFF0D47A1)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text(
                        'GERAR PDF',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        controlle['diametro']!.text = diametroSelecionado;
                        controlle['flange']!.text = conexaoSelecionada;
                        controlle['eletrodo']!.text = eletrodoSelecionado;
                        controlle['revestimento']!.text = revestimentoSelecionado;

                        final camposString = controlle.map((k, c) => MapEntry(k, c.text));

                        await gerarLaudoPDF(
                          context: context,
                          campos: camposString,
                          imagens: imagensSelecionadas,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Gera PDF e salva como "laudoOS<os_com_substituicao>.pdf"
Future<void> gerarLaudoPDF({
  required BuildContext context,
  required Map<String, String> campos,
  required List<File?> imagens,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  // Extrai o texto de OS e substitui '-' por '_'
  String osFull = campos['os'] ?? '';
  String osSlug = osFull.replaceAll('-', '_');

  // Tentar carregar o logo; se falhar, prossegue sem
  pw.ImageProvider? logoImage;
  try {
    final logoBytes = await rootBundle.load('assets/logo.png');
    logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
  } catch (e) {
    print('⚠️ Aviso: não foi possível carregar assets/logo.png: $e');
    logoImage = null;
  }

  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: pw.PageOrientation.portrait,
      build: (pw.Context ctx) => [
        // Cabeçalho azul
        pw.Container(
          color: PdfColor.fromInt(0xFF0D47A1),
          padding: const pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              if (logoImage != null) ...[
                pw.Image(logoImage, width: 40),
                pw.SizedBox(width: 8),
              ],
              pw.Text(
                'LAUDO TÉCNICO',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),

        // Informações Gerais (exibe a OS completa)
        pw.Text(
          'Ordem de Serviço: $osFull',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 14,
          ),
        ),
        pw.Text('Data Emissão: ${campos['dt_laudo']}'),
        pw.Text('Emitido por: ${campos['nome']}'),
        pw.Text('Para: ${campos['para']}'),
        pw.Text('Depto: Instrumentação'),
        pw.SizedBox(height: 12),

        // Identificação do Equipamento
        pw.Container(
          color: PdfColor.fromInt(0xFF0D47A1),
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: pw.Text(
            'Identificação do Equipamento',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(color: PdfColor.fromInt(0xFF0D47A1)),
          headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF0D47A1)),
          headerHeight: 25,
          cellHeight: 30,
          headers: ['SN', 'Fabricante', 'Modelo', 'TAG'],
          data: [
            [
              campos['sn'] ?? '',
              campos['fabricante'] ?? '',
              campos['modelo'] ?? '',
              campos['tag'] ?? '',
            ]
          ],
          headerStyle: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerLeft,
          },
        ),
        pw.SizedBox(height: 12),

        // Parâmetros Técnicos
        pw.Container(
          color: PdfColor.fromInt(0xFF0D47A1),
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: pw.Text(
            'Parâmetros Técnicos',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColor.fromInt(0xFF0D47A1)),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFE3F2FD)),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Ø: ${campos['diametro']}'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Conexão: ${campos['flange']}'),
                ),
              ],
            ),
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.white),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Eletrodo: ${campos['eletrodo']}'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Revestimento: ${campos['revestimento']}'),
                ),
              ],
            ),
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFE3F2FD)),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Isolação Eletrodo 1: ${campos['isol_eletrodo1']} Mohm'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Isolação Eletrodo 2: ${campos['isol_eletrodo2']} Mohm'),
                ),
              ],
            ),
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.white),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Continuidade Eletrodo 1: ${campos['cont_eletrodo1']} Ohm'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Continuidade Eletrodo 2: ${campos['cont_eletrodo2']} Ohm'),
                ),
              ],
            ),
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFFE3F2FD)),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Resistência da Bobina: ${campos['res_bobina']} Ohm'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Text('Isolação da Bobina: ${campos['isol_bobina']} Mohm'),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),

        // Descrição Detalhada
        pw.Container(
          color: PdfColor.fromInt(0xFF0D47A1),
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: pw.Text(
            'Descrição Detalhada',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.SizedBox(height: 8),

        pw.Text('Problema Encontrado:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('${campos['problema']}'),
        pw.SizedBox(height: 6),

        pw.Text('Motivo:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('${campos['motivo']}'),
        pw.SizedBox(height: 6),

        pw.Text('Causa Provável:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('${campos['causa']}'),
        pw.SizedBox(height: 6),

        pw.Text('Ação Corretiva:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('${campos['acao']}'),
        pw.SizedBox(height: 6),

        pw.Text('Conclusão:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text('${campos['conclusao']}'),
        pw.SizedBox(height: 12),

        // Fotos
        pw.Text(
          'Fotos:',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: imagens.where((f) => f != null).map((f) {
            return pw.Container(
              width: 80,
              height: 80,
              child: pw.Image(
                pw.MemoryImage(File(f!.path).readAsBytesSync()),
                fit: pw.BoxFit.cover,
              ),
            );
          }).toList(),
        ),
        pw.SizedBox(height: 20),

        // Rodapé com assinatura e créditos
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(

              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Responsável: ${campos['nm_nome']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 2),
                pw.Text('AC/CI Laboratório de Vazão e Densidade'),
                pw.SizedBox(height: 2),
                pw.Text('Desenvolvido por Vinicius Magalhães'),
              ],
            ),
            // Numeração de páginas removida
          ],
        ),
      ],
    ),
  );

  // Salvando o PDF em getApplicationDocumentsDirectory (funciona no APK)
  if (kIsWeb) {
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  } else {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/laudoOS$osSlug.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    messenger.showSnackBar(
      SnackBar(content: Text('PDF salvo em: $filePath')),
    );

    // Compartilha usando o mesmo nome em lowercase
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'laudoOS$osSlug.pdf');
  }
}
