package com.gojjam.bank.util;

import com.gojjam.bank.model.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class PDFUtil {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final BaseColor DARK_BLUE = new BaseColor(10, 31, 68);
    private static final BaseColor LIGHT_GRAY = new BaseColor(242, 242, 242);

    private PDFUtil() {}

    // ── Header ──────────────────────────────────────────────────────────────────
    private static void addHeader(Document doc, String title) throws DocumentException {
        Font bankFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, DARK_BLUE);
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, DARK_BLUE);

        Paragraph bankName = new Paragraph("🏦 Gojjam International Bank", bankFont);
        bankName.setAlignment(Element.ALIGN_CENTER);
        doc.add(bankName);

        Paragraph sub = new Paragraph("Trusted Banking for Every Ethiopian", 
            FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.GRAY));
        sub.setAlignment(Element.ALIGN_CENTER);
        sub.setSpacingAfter(10f);
        doc.add(sub);

        LineSeparator line = new LineSeparator();
        line.setLineColor(DARK_BLUE);
        doc.add(new Chunk(line));

        Paragraph t = new Paragraph(title, titleFont);
        t.setAlignment(Element.ALIGN_CENTER);
        t.setSpacingBefore(10f);
        t.setSpacingAfter(15f);
        doc.add(t);
    }

    private static PdfPTable createInfoTable(int cols) {
        PdfPTable table = new PdfPTable(cols);
        table.setWidthPercentage(100);
        table.setSpacingBefore(5f);
        table.setSpacingAfter(10f);
        return table;
    }

    private static PdfPCell headerCell(String text) {
        Font f = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
        PdfPCell cell = new PdfPCell(new Phrase(text, f));
        cell.setBackgroundColor(DARK_BLUE);
        cell.setPadding(6f);
        return cell;
    }

    private static PdfPCell dataCell(String text) {
        Font f = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);
        PdfPCell cell = new PdfPCell(new Phrase(text == null ? "N/A" : text, f));
        cell.setPadding(5f);
        return cell;
    }

    private static PdfPCell shadeCell(String text) {
        PdfPCell cell = dataCell(text);
        cell.setBackgroundColor(LIGHT_GRAY);
        return cell;
    }

    private static void addFooter(Document doc) throws DocumentException {
        LineSeparator line = new LineSeparator();
        line.setLineColor(DARK_BLUE);
        doc.add(new Chunk(line));
        Font fFont = FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 9, BaseColor.GRAY);
        Paragraph footer = new Paragraph(
            "This is a system-generated document. Gojjam International Bank © 2024", fFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.setSpacingBefore(5f);
        doc.add(footer);
    }

    // ── Transfer Receipt ────────────────────────────────────────────────────────
    public static void generateTransferReceipt(HttpServletResponse response,
                                                Transfer transfer,
                                                String senderName) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
            "inline; filename=transfer_receipt_" + transfer.getId() + ".pdf");
        Document doc = new Document(PageSize.A5);
        try {
            PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();
            addHeader(doc, "TRANSFER RECEIPT");

            PdfPTable table = createInfoTable(2);
            table.addCell(headerCell("Transaction ID"));
            table.addCell(dataCell(String.valueOf(transfer.getId())));
            table.addCell(shadeCell("Sender Name"));
            table.addCell(shadeCell(senderName));
            table.addCell(headerCell("Sender Account"));
            table.addCell(dataCell(transfer.getSenderAccountNumber()));
            table.addCell(shadeCell("Receiver Account"));
            table.addCell(shadeCell(transfer.getReceiverAccount()));
            table.addCell(headerCell("Transfer Type"));
            table.addCell(dataCell(transfer.getTransferType()));
            table.addCell(shadeCell("Amount (ETB)"));
            table.addCell(shadeCell(transfer.getAmount().toPlainString()));
            table.addCell(headerCell("Fee (ETB)"));
            table.addCell(dataCell(transfer.getFee().toPlainString()));
            table.addCell(shadeCell("Total Debited (ETB)"));
            table.addCell(shadeCell(transfer.getAmount().add(transfer.getFee()).toPlainString()));
            table.addCell(headerCell("Status"));
            table.addCell(dataCell(transfer.getStatus()));
            if (transfer.getBeneficiaryName() != null) {
                table.addCell(shadeCell("Beneficiary"));
                table.addCell(shadeCell(transfer.getBeneficiaryName()));
            }
            if (transfer.getBankName() != null) {
                table.addCell(headerCell("Bank Name"));
                table.addCell(dataCell(transfer.getBankName()));
            }
            table.addCell(shadeCell("Date & Time"));
            table.addCell(shadeCell(transfer.getCreatedAt() != null
                ? transfer.getCreatedAt().format(FMT) : "N/A"));
            doc.add(table);
            addFooter(doc);
        } catch (DocumentException e) {
            throw new IOException("PDF generation error: " + e.getMessage(), e);
        } finally {
            if (doc.isOpen()) doc.close();
        }
    }

    // ── Bill Payment Receipt ─────────────────────────────────────────────────────
    public static void generateBillReceipt(HttpServletResponse response,
                                            BillPayment bill,
                                            String ownerName,
                                            String accountNumber) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
            "inline; filename=bill_receipt_" + bill.getId() + ".pdf");
        Document doc = new Document(PageSize.A5);
        try {
            PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();
            addHeader(doc, "BILL PAYMENT RECEIPT");

            PdfPTable table = createInfoTable(2);
            table.addCell(headerCell("Transaction ID")); table.addCell(dataCell(String.valueOf(bill.getId())));
            table.addCell(shadeCell("Account Holder")); table.addCell(shadeCell(ownerName));
            table.addCell(headerCell("Account Number")); table.addCell(dataCell(accountNumber));
            table.addCell(shadeCell("Bill Type"));      table.addCell(shadeCell(bill.getBillType()));
            table.addCell(headerCell("Provider"));      table.addCell(dataCell(bill.getProviderName()));
            table.addCell(shadeCell("Reference No."));  table.addCell(shadeCell(bill.getReferenceNumber()));
            table.addCell(headerCell("Amount (ETB)"));  table.addCell(dataCell(bill.getAmount().toPlainString()));
            table.addCell(shadeCell("Fee (ETB)"));      table.addCell(shadeCell(bill.getFee().toPlainString()));
            table.addCell(headerCell("Status"));        table.addCell(dataCell(bill.getStatus()));
            table.addCell(shadeCell("Date & Time"));    table.addCell(shadeCell(
                bill.getCreatedAt() != null ? bill.getCreatedAt().format(FMT) : "N/A"));
            doc.add(table);
            addFooter(doc);
        } catch (DocumentException e) {
            throw new IOException("PDF generation error: " + e.getMessage(), e);
        } finally {
            if (doc.isOpen()) doc.close();
        }
    }

    // ── Loan Amortization Schedule ───────────────────────────────────────────────
    public static void generateLoanSchedule(HttpServletResponse response,
                                             Loan loan) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
            "inline; filename=loan_schedule_" + loan.getId() + ".pdf");
        Document doc = new Document(PageSize.A4);
        try {
            PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();
            addHeader(doc, "LOAN APPROVAL & AMORTIZATION SCHEDULE");

            // Loan summary
            PdfPTable summary = createInfoTable(2);
            summary.addCell(headerCell("Loan ID"));        summary.addCell(dataCell(String.valueOf(loan.getId())));
            summary.addCell(shadeCell("Account Holder"));  summary.addCell(shadeCell(loan.getOwnerName()));
            summary.addCell(headerCell("Account Number")); summary.addCell(dataCell(loan.getAccountNumber()));
            summary.addCell(shadeCell("Loan Amount"));     summary.addCell(shadeCell("ETB " + loan.getAmount().toPlainString()));
            summary.addCell(headerCell("Interest Rate"));  summary.addCell(dataCell(loan.getInterestRate().toPlainString() + "% per annum"));
            summary.addCell(shadeCell("Duration"));        summary.addCell(shadeCell(loan.getDurationMonths() + " months"));
            summary.addCell(headerCell("Monthly EMI"));    summary.addCell(dataCell("ETB " + loan.getMonthlyEmi().toPlainString()));
            summary.addCell(shadeCell("Total Payable"));   summary.addCell(shadeCell("ETB " + loan.getTotalPayable().toPlainString()));
            summary.addCell(headerCell("Purpose"));        summary.addCell(dataCell(loan.getPurpose()));
            summary.addCell(shadeCell("Approved On"));     summary.addCell(shadeCell(
                loan.getApprovedAt() != null ? loan.getApprovedAt().format(DATE_FMT) : "N/A"));
            doc.add(summary);

            // Amortization table
            Font hFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);
            PdfPTable amTable = new PdfPTable(5);
            amTable.setWidthPercentage(100);
            amTable.setSpacingBefore(15f);
            amTable.setWidths(new float[]{1f, 2f, 2f, 2f, 2f});
            for (String h : new String[]{"Month","EMI (ETB)","Principal","Interest","Bal. (ETB)"}) {
                PdfPCell c = new PdfPCell(new Phrase(h, hFont));
                c.setBackgroundColor(DARK_BLUE);
                c.setPadding(5f);
                amTable.addCell(c);
            }

            BigDecimal monthlyRate = loan.getInterestRate()
                .divide(BigDecimal.valueOf(12 * 100), 10, java.math.RoundingMode.HALF_UP);
            BigDecimal outstanding = loan.getAmount();
            Font rowFont = FontFactory.getFont(FontFactory.HELVETICA, 9);

            for (int m = 1; m <= loan.getDurationMonths(); m++) {
                BigDecimal interest  = outstanding.multiply(monthlyRate)
                                                  .setScale(2, java.math.RoundingMode.HALF_UP);
                BigDecimal principal = loan.getMonthlyEmi().subtract(interest)
                                                           .setScale(2, java.math.RoundingMode.HALF_UP);
                outstanding = outstanding.subtract(principal).max(BigDecimal.ZERO);

                BaseColor rowColor = (m % 2 == 0) ? LIGHT_GRAY : BaseColor.WHITE;
                for (String val : new String[]{
                    String.valueOf(m),
                    loan.getMonthlyEmi().toPlainString(),
                    principal.toPlainString(),
                    interest.toPlainString(),
                    outstanding.toPlainString()
                }) {
                    PdfPCell c = new PdfPCell(new Phrase(val, rowFont));
                    c.setBackgroundColor(rowColor);
                    c.setPadding(4f);
                    amTable.addCell(c);
                }
            }
            doc.add(amTable);
            addFooter(doc);
        } catch (DocumentException e) {
            throw new IOException("PDF generation error: " + e.getMessage(), e);
        } finally {
            if (doc.isOpen()) doc.close();
        }
    }

    // ── Account Statement ────────────────────────────────────────────────────────
    public static void generateAccountStatement(HttpServletResponse response,
                                                 Account account,
                                                 String ownerName,
                                                 List<Transaction> transactions,
                                                 String fromDate,
                                                 String toDate) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
            "inline; filename=statement_" + account.getAccountNumber() + ".pdf");
        Document doc = new Document(PageSize.A4.rotate());
        try {
            PdfWriter.getInstance(doc, response.getOutputStream());
            doc.open();
            addHeader(doc, "ACCOUNT STATEMENT");

            PdfPTable info = createInfoTable(4);
            info.addCell(headerCell("Account Holder")); info.addCell(dataCell(ownerName));
            info.addCell(headerCell("Account No."));    info.addCell(dataCell(account.getAccountNumber()));
            info.addCell(shadeCell("Account Type"));    info.addCell(shadeCell(account.getAccountType()));
            info.addCell(shadeCell("Current Balance")); info.addCell(shadeCell("ETB " + account.getBalance().toPlainString()));
            info.addCell(headerCell("Period"));         info.addCell(dataCell(fromDate + " – " + toDate));
            info.addCell(headerCell("Total Records"));  info.addCell(dataCell(String.valueOf(transactions.size())));
            doc.add(info);

            PdfPTable txTable = new PdfPTable(6);
            txTable.setWidthPercentage(100);
            txTable.setWidths(new float[]{1.5f, 3f, 2f, 1.5f, 1.5f, 2f});
            txTable.setSpacingBefore(10f);
            for (String h : new String[]{"Ref No.","Type","Amount(ETB)","Fee(ETB)","Status","Date"}) {
                txTable.addCell(headerCell(h));
            }
            Font rowFont = FontFactory.getFont(FontFactory.HELVETICA, 9);
            int row = 0;
            for (Transaction t : transactions) {
                BaseColor color = (row++ % 2 == 0) ? BaseColor.WHITE : LIGHT_GRAY;
                for (String val : new String[]{
                    t.getReferenceNumber(),
                    t.getTransactionType(),
                    t.getAmount().toPlainString(),
                    t.getFee().toPlainString(),
                    t.getStatus(),
                    t.getCreatedAt() != null ? t.getCreatedAt().format(FMT) : "N/A"
                }) {
                    PdfPCell c = new PdfPCell(new Phrase(val == null ? "" : val, rowFont));
                    c.setBackgroundColor(color);
                    c.setPadding(4f);
                    txTable.addCell(c);
                }
            }
            doc.add(txTable);
            addFooter(doc);
        } catch (DocumentException e) {
            throw new IOException("PDF generation error: " + e.getMessage(), e);
        } finally {
            if (doc.isOpen()) doc.close();
        }
    }
}