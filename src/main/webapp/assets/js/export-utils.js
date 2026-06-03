
function exportCSV(headers, rows, filename) {
    const BOM = '\uFEFF';
    const lines = [headers.join(',')];
    rows.forEach(row => {
        lines.push(row.map(cell => {
            const s = String(cell == null ? '' : cell);
            return s.includes(',') || s.includes('"') || s.includes('\n')
                ? '"' + s.replace(/"/g, '""') + '"'
                : s;
        }).join(','));
    });
    const blob = new Blob([BOM + lines.join('\n')], { type: 'text/csv;charset=utf-8;' });
    _download(blob, filename + '.csv');
}

function exportExcel(headers, rows, filename, sheetName) {
    if (typeof XLSX === 'undefined') {
        alert('Đang tải thư viện Excel, vui lòng thử lại sau vài giây...');
        return;
    }
    const data = [headers, ...rows];
    const ws   = XLSX.utils.aoa_to_sheet(data);
    const wb   = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, sheetName || 'Sheet1');

    // Căn chỉnh độ rộng cột tự động
    const colWidths = headers.map((h, i) => ({
        wch: Math.max(h.length, ...rows.map(r => String(r[i] || '').length)) + 2
    }));
    ws['!cols'] = colWidths;

    XLSX.writeFile(wb, filename + '.xlsx');
}

function exportPDF(headers, rows, filename, title) {
    if (typeof window.jspdf === 'undefined' && typeof jsPDF === 'undefined') {
        alert('Đang tải thư viện PDF, vui lòng thử lại sau vài giây...');
        return;
    }
    const { jsPDF } = window.jspdf || window;
    const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' });

    doc.addFont('https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxK.woff2', 'Roboto', 'normal');

    if (title) {
        doc.setFontSize(14);
        doc.setFont('helvetica', 'bold');
        doc.text(title, 14, 16);
    }
    doc.setFontSize(9);
    doc.setFont('helvetica', 'normal');
    doc.text('Xuất lúc: ' + new Date().toLocaleString('vi-VN'), 14, title ? 22 : 14);

    doc.autoTable({
        head:       [headers],
        body:       rows,
        startY:     title ? 27 : 20,
        styles:     { font: 'helvetica', fontSize: 9, cellPadding: 3 },
        headStyles: { fillColor: [79, 70, 229], textColor: 255, fontStyle: 'bold' },
        alternateRowStyles: { fillColor: [248, 249, 250] },
        margin: { left: 14, right: 14 }
    });

    doc.save(filename + '.pdf');
}

function _download(blob, name) {
    const url = URL.createObjectURL(blob);
    const a   = document.createElement('a');
    a.href    = url;
    a.download = name;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { URL.revokeObjectURL(url); a.remove(); }, 500);
}

function fmtVND(v) {
    return new Intl.NumberFormat('vi-VN').format(v) + ' đ';
}