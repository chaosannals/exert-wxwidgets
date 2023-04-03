#include <wx/wxprec.h>
#include <wx/wx.h>
#include <wx/image.h>
#include <wx/imagpng.h>
#include <wx/imagjpeg.h>
#include <wx/wxhtml.h>
#include <wx/statline.h>

class MyFrame : public wxFrame
{
public:
    // 显示调用 wxFrame 构造函数，默认无参构造函数没有删掉。不显示写，会调用默认无参构造函数，导致没有初始化窗口。
    MyFrame(const wxString& title): wxFrame(nullptr, wxID_ANY, title) {
        SetIcon(wxICON(sample));

        // create a menu bar
        wxMenu* menuFile = new wxMenu;

        menuFile->Append(wxID_ABOUT);
        menuFile->Append(wxID_EXIT);

        // now append the freshly created menu to the menu bar...
        wxMenuBar* menuBar = new wxMenuBar;
        menuBar->Append(menuFile, _("&File"));

        // ... and attach this menu bar to the frame
        SetMenuBar(menuBar);
    }

    // event handlers (these functions should _not_ be virtual)
    void OnQuit(wxCommandEvent& event) {
        Close(true);
    }
    void OnAbout(wxCommandEvent& event) {
        wxBoxSizer* topsizer;
        wxHtmlWindow* html;
        wxDialog dlg(this, wxID_ANY, wxString(_("About")));

        topsizer = new wxBoxSizer(wxVERTICAL);

        html = new wxHtmlWindow(&dlg, wxID_ANY, wxDefaultPosition, wxSize(380, 160), wxHW_SCROLLBAR_NEVER);
        html->SetBorders(0);
        html->LoadPage("data/about.htm");
        html->SetHTMLBackgroundImage(wxBitmapBundle::FromSVGFile("data/bg.svg", wxSize(65, 45)));
        html->SetInitialSize(wxSize(html->GetInternalRepresentation()->GetWidth(),
            html->GetInternalRepresentation()->GetHeight()));

        topsizer->Add(html, 1, wxALL, 10);

#if wxUSE_STATLINE
        topsizer->Add(new wxStaticLine(&dlg, wxID_ANY), 0, wxEXPAND | wxLEFT | wxRIGHT, 10);
#endif // wxUSE_STATLINE

        wxButton* bu1 = new wxButton(&dlg, wxID_OK, _("OK"));
        bu1->SetDefault();

        topsizer->Add(bu1, 0, wxALL | wxALIGN_RIGHT, 15);

        dlg.SetSizer(topsizer);
        topsizer->Fit(&dlg);

        dlg.ShowModal();
    }

private:
    // any class wishing to process wxWidgets events must use this macro
    wxDECLARE_EVENT_TABLE();
};

class MyApp : public wxApp
{
public:
    virtual bool OnInit() override {
        if (!wxApp::OnInit())
            return false;

        wxImage::AddHandler(new wxPNGHandler);

        MyFrame* frame = new MyFrame(_("wxHtmlWindow testing application"));
        frame->Show();

        return true;
    }
};

// 该宏实现 跨平台的主函数，Windows 下是 WinMain 定义
wxIMPLEMENT_APP(MyApp);

// 靠这些宏注册 MyFrame 以及它的事件。
wxBEGIN_EVENT_TABLE(MyFrame, wxFrame)
EVT_MENU(wxID_ABOUT, MyFrame::OnAbout)
EVT_MENU(wxID_EXIT, MyFrame::OnQuit)
wxEND_EVENT_TABLE()