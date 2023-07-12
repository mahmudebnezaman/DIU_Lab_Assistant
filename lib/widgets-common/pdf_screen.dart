import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
  final String pdfUrl;

  const PDFScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool _isLoading = true;
  late PDFViewController _pdfViewController;
  int _currentPage = 0;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.pdfUrl,
            onViewCreated: _onPDFViewCreated,
            onPageChanged: _onPageChanged,
            onRender: (_pages) {
              setState(() {
                _isLoading = false;
                _totalPages = _pages!;
              });
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              'Page ${_currentPage + 1} of $_totalPages',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _onPDFViewCreated(PDFViewController pdfViewController) {
    setState(() {
      _pdfViewController = pdfViewController;
    });
  }

  void _onPageChanged(int? page, int? total) {
    setState(() {
      _currentPage = page ?? 0;
      _totalPages = total ?? 0;
    });
  }
}
