import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PickerMode { yearList, decadeList }

class YearSelectorDialog extends StatefulWidget {
  final int? selectedYear;
  final int maxYear;
  final int minYear;

  const YearSelectorDialog({
    super.key,
    this.selectedYear,
    this.maxYear = 2025, // 預設值，可傳入 DateTime.now().year
    this.minYear = 1900,
  });

  @override
  State<YearSelectorDialog> createState() => _YearSelectorDialogState();
}

class _YearSelectorDialogState extends State<YearSelectorDialog> {
  PickerMode _mode = PickerMode.yearList;
  late int _startYear;
  int _decadeStartYear = 1900;

  @override
  void initState() {
    super.initState();

    // 年份選擇格用
    _startYear = widget.maxYear - (widget.maxYear % 9);

    // Decade 起點：讓 maxYear 所在 decade 出現在頁面中間
    final decadeOfMaxYear = (widget.maxYear ~/ 9) * 9;
    _decadeStartYear = decadeOfMaxYear - (9 * 4); // 顯示 9 組，第5格是 maxYear 所在
  }

  void _nextPage() {
    setState(() {
      if (_mode == PickerMode.yearList) {
        if (_startYear + 9 <= widget.maxYear) {
          _startYear += 9;
        }
      } else {
        _decadeStartYear += 9 * 9; // 一次跳 9 組 decade
      }
    });
  }

  void _prevPage() {
    setState(() {
      if (_mode == PickerMode.yearList) {
        if (_startYear - 9 >= widget.minYear) {
          _startYear -= 9;
        }
      } else {
        if (_decadeStartYear - 9 * 9 >= widget.minYear) {
          _decadeStartYear -= 9 * 9;
        }
      }
    });
  }

  void _switchToDecadeMode() {
    setState(() => _mode = PickerMode.decadeList);
  }

  void _selectDecade(int base) {
    setState(() {
      _startYear = base;
      _mode = PickerMode.yearList;
    });
  }

  void _selectYear(int year) {
    Navigator.of(context).pop(year);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16), 
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(thickness: 1.2),
            const SizedBox(height: 8),
            _mode == PickerMode.yearList
                ? _buildYearGrid()
                : _buildDecadeGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _prevPage,
          color: const Color(0xFF2F7E87),
        ),
        GestureDetector(
          onTap: _switchToDecadeMode,
          child: const Text(
            '請選擇年份',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F7E87),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _nextPage,
          color: const Color(0xFF2F7E87),
        ),
      ],
    );
  }

  Widget _buildYearGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: List.generate(9, (index) {
        final year = _startYear + index;
        final isDisabled = year > widget.maxYear;
        final isSelected = year == widget.selectedYear;

        return GestureDetector(
          onTap: isDisabled ? null : () => _selectYear(year),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDisabled
                  ? null
                  : isSelected
                      ? const Color.fromARGB(255, 140, 189, 196)
                      : null,
              // border: isSelected
              //     ? Border.all(color: const Color(0xFF2F7E87), width: 2)
              //     : null,
            ),
            child: Text(
              year.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDisabled
                    ? Colors.grey
                    : isSelected
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color(0xFF2F7E87),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDecadeGrid() {
    final List<int> decades = List.generate(9, (i) => _decadeStartYear + i * 9)
        .where((year) => year + 8 >= widget.minYear && year <= widget.maxYear)
        .toList();
    ;
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 1.5,
      children: decades.map((baseYear) {
        return GestureDetector(
          onTap: () => _selectDecade(baseYear),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Text(
              '$baseYear ~ ${baseYear + 9}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F7E87),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
